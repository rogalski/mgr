% Experiment 2: nesdisres algorithm vs others
testcases = dir(fullfile('test_suites', 'basic', '*.mat'));
tc_count = length(testcases);

RESULTS_DIR = fullfile('results', 'ex3_nesdisred_reduction_time');
mkdir(RESULTS_DIR);

EXPORTS_DIR = fullfile('exports', 'ex3_nesdisred_reduction_time');
mkdir(EXPORTS_DIR);

% Test matrix definition - reduction params
testMatrix_costFuncs = {@cost_res2_nodes};
testMatrix_costFuncs_empty = {[]};
testMatrix_nesDisOpts = {[200 0 1 0]};
testMatrix_emptyNesDisOpts = {[]};

testMatrix = [
    allcomb({'nesdis_camd'}, testMatrix_costFuncs, testMatrix_nesDisOpts);
    allcomb({'camd'}, testMatrix_costFuncs, testMatrix_emptyNesDisOpts);
];

for c = testMatrix'
    elimScheme = c{1};
    costFunc = c{2};
    nesdisOpts = c{3};

    results_group = elimScheme;
    
    % build struct
    options = struct;
    options.verbose = 0;
    options.nodewise_algorithm = elimScheme;
    options.graph_algorithm = 'standard';
    if ~isempty(costFunc)
        options.cost_function = costFunc;
    end
    if ~isempty(costFunc)
        options.nesdis_opts = nesdisOpts;
    end
    
    reducer_warmup(options);
    
    % Run testcases
    for f = testcases'
        fname = fullfile('test_suites', 'basic', f.name);
        [tc_dir, tc_name, ext] = fileparts(f.name);
        output_filename = @(suffix) fullfile(RESULTS_DIR, [tc_name suffix]);

        if exist(output_filename([results_group '.mat']), 'file') == 2
            continue
        end
        tc_name
        load(fname);
        input_circuit_info = circuit_info(G, is_ext_node);

        tic
        output = reducer(G, is_ext_node, options);
        output.total_time = toc;
        
        i = input_for_circuit_composite_info(output);
        output_circuit_info = circuit_composite_info(i{:});

        save(output_filename([results_group '.mat']), 'input_circuit_info', 'output', 'output_circuit_info', 'G', 'is_ext_node');
    end
end

selectMatrix = [
    allcomb({'nesdis_camd'}, testMatrix_costFuncs, testMatrix_nesDisOpts);
    allcomb({'camd'}, testMatrix_costFuncs, testMatrix_emptyNesDisOpts);
];

group_count = size(selectMatrix, 1);

num_nodes_orig = nan(tc_count, 1);
num_nodes_red = nan(tc_count, group_count);
num_term_orig = nan(tc_count, 1);
num_term_red = nan(tc_count, group_count);
num_res_orig = nan(tc_count, 1);
num_res_red = nan(tc_count, group_count);
red_total_time = nan(tc_count, group_count);

tc_num = 0;
for f = testcases'
    [tc_dir, tc_name, ext] = fileparts(f.name);
    tc_name
    output_filename = @(suffix) fullfile(RESULTS_DIR, [tc_name suffix]);

    tc_num = tc_num+1;
    group_num = 0;
    for c=selectMatrix'
        group_num = group_num+1;
       
        elimScheme = c{1};
        costFunc = c{2};
        nesdisOpts = c{3};
        
        results_group = elimScheme;

        try
            load(output_filename([results_group '.mat']),  'input_circuit_info', 'output', 'output_circuit_info', 'G', 'is_ext_node');
        catch error
            continue
        end

        num_nodes_orig(tc_num, 1) = input_circuit_info.num_nodes;
        num_nodes_red(tc_num, group_num) = output_circuit_info.num_nodes;
        num_term_orig(tc_num, 1) = input_circuit_info.num_external;
        num_term_red(tc_num, group_num) = output_circuit_info.num_external;
        num_res_orig(tc_num, 1) = input_circuit_info.num_resistors;
        num_res_red(tc_num, group_num) = output_circuit_info.num_resistors;
        red_total_time(tc_num, group_num) = output.total_time;
    end
end

reduction_speedup = 100 * (red_total_time(:, 2) ./ red_total_time(:, 1) - 1);

T = table(num_nodes_orig,num_term_orig,num_res_orig,...
    num_nodes_red,num_res_red, red_total_time, reduction_speedup, ...
    'RowNames', arrayfun(@(s) s.name, testcases, 'UniformOutput', false))
writetable(T, fullfile(EXPORTS_DIR, 'nesdisred_speedup.csv'))
