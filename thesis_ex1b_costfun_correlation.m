% Experiment 1b: correlation on cost functions
close all;
testcases = dir(fullfile('test_suites', 'basic', '*.mat'));
testcases = sortStruct(testcases, 'bytes');
testcases = testcases(1:5);

tc_count = length(testcases);

RESULTS_DIR = fullfile('results', 'ex1b_costfun_correlation');
mkdir(RESULTS_DIR);

ngspice_functions = {@ngspice.get_matrix_load_time, @ngspice.get_matrix_reorder_time, ...
    @ngspice.get_matrix_factor_time, @ngspice.get_matrix_solve_time, ...
    @ngspice.get_simulation_time};
ngspice_functions_legend = cellfun(@(h) func2str(h), ngspice_functions, 'UniformOutput', 0);

cost_functions = {@count_resistors, @cost_res_nodes, @cost_res2_nodes};
cost_functions_legend = cellfun(@(h) func2str(h), cost_functions, 'UniformOutput', 0);

for f=testcases'
    fname = fullfile('test_suites', 'basic', f.name);
    load(fname, 'G', 'is_ext_node')
    
    % preprocess problem by using graph_reduce - reduce trivial cases
    o = graph_reduce( G, is_ext_node, adj(G));
    G = o.G;
    is_ext_node = o.is_ext_node;
    
    avg_degrees = full(mean(degrees(adj(G))));
    step = floor(length(G) / 100);
    if (step == 0); step = 1; end
    
    results_dir = fullfile(RESULTS_DIR, f.name);
    mkdir(results_dir);
    tmp_dir = fullfile(results_dir, 'tmp');
    
    if(length(G)) < 500
        dotf = fullfile(results_dir, [f.name '.dot']);
        dotfiles.dump(dotf, G, is_ext_node);
        try
            graphviz.run_fdp(dotf);
        catch e
        end
    end
    
    [datapoints, costs, stats] = run_nodewise_experiment(G, is_ext_node, step, cost_functions, ngspice_functions, tmp_dir, 1, 5);
    for c_idx = 1:length(cost_functions)
        cost_func_name = cost_functions_legend(c_idx);
        figure('Visible', 'off');
        plotyy(datapoints, costs(c_idx, :), datapoints, stats(5, :))
        title([f.name 'cost vs sim time'], 'interpreter', 'none')
        legend([cost_func_name {'simulation time'}], 'interpreter', 'none');
        saveas(gcf, fullfile(results_dir, [num2str(c_idx) '_' cost_func_name{1} '.png']))
    end
    figure('Visible', 'off');
    title([f.name 'sample stats'], 'interpreter', 'none')
    plot(datapoints, stats(1:4, :))
    legend(ngspice_functions_legend(1:4), 'interpreter', 'none');
    
    bar_data = [stats(1:4, :); stats(5, :) - sum(stats(1:4, :))];
    bars = bsxfun(@rdivide, bar_data, stats(5, :));
    bar(datapoints, bars', 'stacked', 'BarWidth', 1)
    legend({'loadtime', 'reordertime', 'factortime', 'solvetime', 'unaccounted'})
    
    saveas(gcf, fullfile(results_dir, 'time_distribution.png'))
    
    R = corrcoef([stats(5,:)' costs']);
    save(fullfile(results_dir, 'stats.txt'),'R', 'avg_degrees', '-ascii')
end
