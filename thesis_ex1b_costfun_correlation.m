% Experiment 1b: correlation on cost functions
close all;
testcases = dir(fullfile('test_suites', 'basic', '*.mat'));
testcases = testcases(68);
tc_count = length(testcases);

RESULTS_DIR = fullfile('results', 'ex1b_costfun_correlation');
mkdir(RESULTS_DIR);

ngspice_functions = {@ngspice.get_matrix_load_time, @ngspice.get_matrix_reorder_time, ...
    @ngspice.get_matrix_factor_time, @ngspice.get_matrix_solve_time, ...
    @ngspice.get_simulation_time};
ngspice_functions_legend = cellfun(@(h) func2str(h), ngspice_functions, 'UniformOutput', 0);

cost_functions = {@count_resistors, @cost_res_nodes, @cost_res2_nodes};
cost_functions_names = cellfun(@(h) func2str(h), cost_functions, 'UniformOutput', 0);
cost_functions_nicenames = {'f(G) = k_G', 'f(G) = k_G*n_G', 'f(G) = k_G^2 n_G'};
USE_CAMD = 1;
ITERATIONS = 5;

for f=testcases'
    fname = fullfile('test_suites', 'basic', f.name);
    load(fname, 'G', 'is_ext_node')
    
    % preprocess problem by using graph_reduce - reduce trivial cases
    o = graph_reduce( G, is_ext_node, adj(G));
    G = o.G;
    is_ext_node = o.is_ext_node;
    
    avg_degrees = full(mean(degrees(adj(G))));
    step = floor(length(G) / 25);
    if (step == 0); step = 1; end
    
    results_dir = fullfile(RESULTS_DIR, f.name);
    if exist(fullfile(results_dir, 'raw.mat'), 'file')
        load(fullfile(results_dir, 'raw.mat'))
    else
        mkdir(results_dir);
        tmp_dir = fullfile(results_dir, 'tmp');
        [datapoints, costs, times_data] = run_nodewise_experiment(G, is_ext_node, step, cost_functions, ngspice_functions, tmp_dir, USE_CAMD, ITERATIONS);
    end
    
    stats = median(times_data, 3);
    R = corrcoef([stats(5,:)' costs']);
    
    for c_idx = 1:length(cost_functions)
        cost_func_name = cost_functions_names(c_idx);
        cost_func_nicename = cost_functions_nicenames(c_idx);
        figure('Visible', 'off');
        plotyy(datapoints, costs(c_idx, :), datapoints, stats(5, :))
        [a,b,c] = fileparts(f.name);
        n = str2double(b);
        % title(['obwod testowy #' num2str(n) ' - czas symulacji a funkcja kosztu'], 'interpreter', 'none')
        legend([cost_func_nicename {'czas symulacji'}]);
        dim = [.2 .2 .1 .1];
        str = ['R=' num2str(R(1,c_idx+1))] ;
        annotation('textbox',dim,'String',str,'FitBoxToText','on');
        xlabel('Liczba wyeliminowanych wêz³ów wewnêtrznych')
        saveas(gcf, fullfile(results_dir, [num2str(c_idx) '_' cost_func_name{1} '.eps']), 'epsc')
    end
    figure('Visible', 'off');
    title([f.name 'sample stats'], 'interpreter', 'none')
    plot(datapoints, stats(1:4, :))
    legend(ngspice_functions_legend(1:4), 'interpreter', 'none');
    
    bar_data = [stats(1:4, :); stats(5, :) - sum(stats(1:4, :))];
    bars = bsxfun(@rdivide, bar_data, stats(5, :));
    bar(datapoints, bars', 'stacked', 'BarWidth', 1)
    legend({'loadtime', 'reordertime', 'factortime', 'solvetime', 'unaccounted'})
    
    saveas(gcf, fullfile(results_dir, 'time_distribution.eps'), 'epsc')
    
    R = corrcoef([stats(5,:)' costs']);
    [~, bestFunc] = max(R(1,2:end));
    if ~exist(fullfile(results_dir, 'raw.mat'), 'file')
        save(fullfile(results_dir, 'raw.mat'), 'datapoints', 'costs', 'times_data', 'stats', 'R', 'bestFunc')
    end
end


results = dir(fullfile(RESULTS_DIR, '*.mat'));
corrcoeffs = nan(length(results), 3);
idx = 0;
for d=results'
    idx = idx+1;
    load(fullfile(RESULTS_DIR, d.name, 'raw.mat'));
    fprintf(1, '%s - %s (%s)\n', d.name, char(cost_functions_names(bestFunc)), mat2str(R(1,2:end)));
    corrcoeffs(idx, :) = R(1,2:end);
end
corrcoeffs == repmat(max(corrcoeffs, [], 2), 1, 3)

