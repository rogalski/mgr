% Experiment 2: nesdisres algorithm vs others
testcases = dir(fullfile('test_suites', 'big', '*.mat'));
testcases = testcases(1:end-1);
tc_count = length(testcases);

RESULTS_DIR = fullfile('results', 'ex2_nesdisred_vs_camd');
mkdir(RESULTS_DIR);

EXPORTS_DIR = fullfile('exports', 'ex2_nesdisred_vs_camd');
mkdir(EXPORTS_DIR);

REFERENCE_DIR = fullfile('results', 'reference');

% Test matrix definition - reduction params
testMatrix_costFuncs = {@cost_res2_nodes};
testMatrix_costFuncs_empty = {[]};
testMatrix_nesDisOpts = {[1000 0 1 0]};
testMatrix_nesDisDummyOpts = {[5 0 1 0]};
testMatrix_emptyNesDisOpts = {[]};

testMatrix = [
    allcomb({'nesdis_camd'}, testMatrix_costFuncs, testMatrix_nesDisOpts);
    allcomb({'nesdis_dummy'}, testMatrix_costFuncs_empty, testMatrix_nesDisDummyOpts);
    allcomb({'camd'}, testMatrix_costFuncs, testMatrix_emptyNesDisOpts);
    ];

for c = testMatrix'
    elimScheme = c{1};
    costFunc = c{2};
    nesdisOpts = c{3};
    
    if isempty(costFunc) costFuncName = ''; else costFuncName = func2str(costFunc); end
    if isempty(nesdisOpts) nesDisSuffix = ''; else nesDisSuffix = num2str(nesdisOpts(1)); end
    results_group = strjoin({elimScheme costFuncName num2str(nesDisSuffix)}, '-');
    
    % build struct
    options = struct;
    options.verbose = 0;
    options.early_exit = 1;
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
        fname = fullfile('test_suites', 'big', f.name);
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
        
        i = input_for_dump(output);
        netlists.dump_composite(output_filename([results_group '.red.cir']), i{:});
        ngspice.run(output_filename([results_group '.red.cir']));
    end
end

selectMatrix = testMatrix;
group_count = size(selectMatrix, 1);

time_solve_orig = nan(tc_count, group_count);
time_solve_red = nan(tc_count, group_count);
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
    output_filename = @(suffix) fullfile(RESULTS_DIR, [tc_name suffix]);
    
    tc_num = tc_num+1;
    group_num = 0;
    for c=selectMatrix'
        group_num = group_num+1;
        
        elimScheme = c{1};
        costFunc = c{2};
        nesdisOpts = c{3};
        if isempty(costFunc) costFuncName = ''; else costFuncName = func2str(costFunc); end
        if isempty(nesdisOpts) nesDisSuffix = ''; else nesDisSuffix = num2str(nesdisOpts(1)); end
        results_group = strjoin({elimScheme costFuncName num2str(nesDisSuffix)}, '-');
        
        load(output_filename([results_group '.mat']),  'input_circuit_info', 'output', 'output_circuit_info', 'G', 'is_ext_node');
        
        num_nodes_orig(tc_num, 1) = input_circuit_info.num_nodes;
        num_nodes_red(tc_num, group_num) = output_circuit_info.num_nodes;
        num_term_orig(tc_num, 1) = input_circuit_info.num_external;
        num_term_red(tc_num, group_num) = output_circuit_info.num_external;
        num_res_orig(tc_num, 1) = input_circuit_info.num_resistors;
        num_res_red(tc_num, group_num) = output_circuit_info.num_resistors;
        red_total_time(tc_num, group_num) = output.total_time;
        time_solve_orig(tc_num, group_num) = ngspice.get_simulation_time(fullfile(REFERENCE_DIR, [tc_name '.log']));
        time_solve_red(tc_num, group_num) = ngspice.get_simulation_time(output_filename([results_group '.red.log']));
    end
end

performance_improvement_percentage = 100 * (time_solve_orig ./ time_solve_red - 1);
cnt_res_vs_res2n = 100 * (time_solve_red(:, 1) ./ time_solve_red(:, 2) - 1);

T = table(num_nodes_orig,num_term_orig,num_res_orig,...
    num_nodes_red,num_res_red, ...
    'RowNames', arrayfun(@(s) s.name, testcases, 'UniformOutput', false))
writetable(T, fullfile(EXPORTS_DIR, 'nesdisred_camd_cmp.csv'))

figure;
bar(time_solve_orig ./ time_solve_red)
hold on;
plot([0 tc_count+1], [1 1], '-. black');
hold off;
legend('nesdisred(1000, camd)', 'nesdisred(5)', 'camd', 'obw�d niezredukowany')
ylabel('t_{orig} / t_{red} [s/s]')
xlabel('Nr obwodu testowego')
print(fullfile(EXPORTS_DIR, 'solve_time.eps'), '-depsc')

figure;
bar(red_total_time);
legend('nesdisred(1000, camd)', 'nesdisred(5)', 'camd*')
ylabel('Czas trwania procesu redukcji [s]')
xlabel('Nr obwodu testowego')
print(fullfile(EXPORTS_DIR, 'reduction_time.eps'), '-depsc')
