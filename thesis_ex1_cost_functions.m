% Experiment 1: search for better cost function in reduction phase
testcases = dir(fullfile('test_suites', 'big', '*.mat'));
testcases = testcases(1:end-1);  % skip mrewiens o1
tc_count = length(testcases);

RESULTS_DIR = fullfile('results', 'ex1_cost_functions');
mkdir(RESULTS_DIR);

REFERENCE_DIR = fullfile('results', 'reference');

EXPORTS_DIR = fullfile('exports', 'ex1_cost_functions');
mkdir(EXPORTS_DIR);

testMatrix_costFunctions = {
    @count_resistors
    @cost_res_nodes
    @cost_res2_nodes
};

for func = testMatrix_costFunctions'
    % Build options struct
    options = struct;
    options.verbose = 0;
    options.early_exit = 1;
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

time_solve_orig = nan(tc_count, group_count);
time_solve_red = nan(tc_count, group_count);
num_nodes_orig = nan(tc_count, 1);
num_nodes_red = nan(tc_count, group_count);
num_term_orig = nan(tc_count, 1);
num_term_red = nan(tc_count, group_count);
num_res_orig = nan(tc_count, 1);
num_res_red = nan(tc_count, group_count);


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
cnt_res_vs_resn = 100 * (time_solve_red(:, 1) ./ time_solve_red(:, 2) - 1);
cnt_res_vs_res2n = 100 * (time_solve_red(:, 1) ./ time_solve_red(:, 3) - 1);

T = table(num_nodes_orig,num_term_orig,num_res_orig,...
    num_nodes_red,num_res_red,time_solve_orig, time_solve_red, ...
    performance_improvement_percentage, cnt_res_vs_resn, cnt_res_vs_res2n, ...
    'RowNames', arrayfun(@(s) s.name, testcases, 'UniformOutput', false))
writetable(T, fullfile(EXPORTS_DIR, 'cost_results.csv'))


plot_time_red = time_solve_red';
plot_time_red = bsxfun(@rdivide, plot_time_red, plot_time_red(1, :));
plot_perf_improvement = 1 ./ plot_time_red;

bar(plot_perf_improvement')
hold on;
plot([0 tc_count+1], [1 1], '-. black');
hold off;
legend('f(G) = k_G', 'f(G) = k_G n_G', 'f(G) = k^2_G n_G', 'warto¶æ referencyjna')
xlabel('Nr obwodu testowego')
ylabel('Wzglêdna wydajno¶æ symulacji obwodu zredukowanego')
print(fullfile(EXPORTS_DIR, 'cost_func.eps'), '-depsc')
