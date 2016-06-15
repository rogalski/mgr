% Experiment 1: search for better cost function in reduction phase
testcases = dir(fullfile('test_suites', 'big', '*.mat'));
tc_count = length(testcases);

RESULTS_DIR = fullfile('results', 'ex1_cost_functions');
mkdir(RESULTS_DIR);

REFERENCE_DIR = fullfile('results', 'reference');

testMatrix_costFunctions = {
    @count_resistors
    @cost_res2_nodes
    ... @cost_res_nodes
};

for func = testMatrix_costFunctions'
    % Build options struct
    options = struct;
    options.verbose = 0;
    options.nodewise_algorithm = 'camd';
    options.graph_algorithm = 'standard';
    options.cost_function = func{1};
    
    func_name = func2str(options.cost_function);

    reducer_warmup(options);
    
    % Run testcases
    for f = testcases'
        fname = fullfile('test_suites', 'big', f.name);
        [tc_dir, tc_name, ext] = fileparts(f.name);
        output_filename = @(suffix) fullfile(RESULTS_DIR, [tc_name suffix]);

        if exist(output_filename([func_name '.mat']), 'file') == 2
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

        save(output_filename([func_name '.mat']), 'input_circuit_info', 'output', 'output_circuit_info', 'G', 'is_ext_node');

        i = input_for_dump(output);
        netlists.dump_composite(output_filename([func_name '.red.cir']), i{:});
        ngspice.run(output_filename([func_name '.red.cir']));
    end
end

group_count = length(testMatrix_costFunctions);

time_solve_orig = zeros(tc_count, group_count);
time_solve_red = zeros(tc_count, group_count);
num_nodes_orig = zeros(tc_count, 1);
num_nodes_red = zeros(tc_count, group_count);
num_term_orig = zeros(tc_count, 1);
num_term_red = zeros(tc_count, group_count);
num_res_orig = zeros(tc_count, 1);
num_res_red = zeros(tc_count, group_count);


tc_num = 0;
for f = testcases'
    [tc_dir, tc_name, ext] = fileparts(f.name);
    output_filename = @(suffix) fullfile(RESULTS_DIR, [tc_name suffix]);

    tc_num = tc_num+1;
    group_num = 0;
    for g=testMatrix_costFunctions'
        group_num = group_num+1;
        func_name = func2str(g{1});

        load(output_filename([func_name '.mat']),  'input_circuit_info', 'output', 'output_circuit_info', 'G', 'is_ext_node');

        num_nodes_orig(tc_num, 1) = input_circuit_info.num_nodes;
        num_nodes_red(tc_num, group_num) = output_circuit_info.num_nodes;
        num_term_orig(tc_num, 1) = input_circuit_info.num_external;
        num_term_red(tc_num, group_num) = output_circuit_info.num_external;
        num_res_orig(tc_num, 1) = input_circuit_info.num_resistors;
        num_res_red(tc_num, group_num) = output_circuit_info.num_resistors;
       
        time_solve_orig(tc_num, group_num) = ngspice.get_simulation_time(fullfile(REFERENCE_DIR, [tc_name '.log']));
        time_solve_red(tc_num, group_num) = ngspice.get_simulation_time(output_filename([func_name '.red.log']));
    end
end

performance_improvement_percentage = 100 * (time_solve_orig ./ time_solve_red - 1);
cnt_res_vs_res2n = 100 * (time_solve_red(:, 1) ./ time_solve_red(:, 2) - 1);

T = table(num_nodes_orig,num_term_orig,num_res_orig,...
    num_nodes_red,num_res_red,time_solve_orig, time_solve_red, ...
    performance_improvement_percentage, cnt_res_vs_res2n, ...
    'RowNames', arrayfun(@(s) s.name, testcases, 'UniformOutput', false))
