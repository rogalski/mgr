% Experiment 1: search for better cost function in reduction phase
testcases = dir(fullfile('test_suites', 'big', '*.mat'));
testcases = testcases(1:end-1);
tc_count = length(testcases);

RESULTS_DIR = fullfile('results', 'ex4_early_exit');
mkdir(RESULTS_DIR);

REFERENCE_DIR = fullfile('results', 'reference');

EXPORTS_DIR = fullfile('exports', 'ex4_early_exit');
mkdir(EXPORTS_DIR);

testMatrix_earlyexit = [0; 1];

for ee = testMatrix_earlyexit'
    % Build options struct
    options = struct;
    options.verbose = 0;
    options.nodewise_algorithm = 'camd';
    options.graph_algorithm = 'standard';
    options.cost_function = @count_resistors;
    options.early_exit = ee;
    
    reducer_warmup(options);
    % Run testcases
    for f = testcases'
        fname = fullfile('test_suites', 'big', f.name);
        [tc_dir, tc_name, ext] = fileparts(f.name);
        output_filename = @(isEarlyExit, suffix) fullfile(RESULTS_DIR, [tc_name num2str(isEarlyExit) '.' suffix]);
        
        if exist(output_filename(ee, 'mat'), 'file') == 2
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
        
        save(output_filename(ee, 'mat'), 'input_circuit_info', 'output', 'output_circuit_info', 'G', 'is_ext_node');
        
        i = input_for_dump(output);
        netlists.dump_composite(output_filename(ee, 'cir'), i{:});
        ngspice.run(output_filename(ee, 'cir'));
    end
end

group_count = length(testMatrix_earlyexit);

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
    output_filename = @(isEarlyExit, suffix) fullfile(RESULTS_DIR, [tc_name num2str(isEarlyExit) '.' suffix]);
    
    tc_num = tc_num+1;
    group_num = 0;
    for isEarlyExit = testMatrix_earlyexit'
        group_num = group_num+1;
        load(output_filename(isEarlyExit, 'mat'),  'input_circuit_info', 'output', 'output_circuit_info', 'G', 'is_ext_node');
        
        num_nodes_orig(tc_num, 1) = input_circuit_info.num_nodes;
        num_nodes_red(tc_num, group_num) = output_circuit_info.num_nodes;
        num_term_orig(tc_num, 1) = input_circuit_info.num_external;
        num_term_red(tc_num, group_num) = output_circuit_info.num_external;
        num_res_orig(tc_num, 1) = input_circuit_info.num_resistors;
        num_res_red(tc_num, group_num) = output_circuit_info.num_resistors;
        red_total_time(tc_num, group_num) = output.total_time;
        
        time_solve_orig(tc_num, group_num) = ngspice.get_simulation_time(fullfile(REFERENCE_DIR, [tc_name '.log']));
        time_solve_red(tc_num, group_num) = ngspice.get_simulation_time(output_filename(isEarlyExit, 'log'));
    end
end

no_early_exit_vs_early_exit = 100 * (red_total_time(:, 1) ./ red_total_time(:, 2) - 1);

T = table(num_nodes_orig,num_term_orig,num_res_orig,...
    num_nodes_red,num_res_red,time_solve_orig, time_solve_red, ...
    red_total_time, no_early_exit_vs_early_exit, ...
    'RowNames', arrayfun(@(s) s.name, testcases, 'UniformOutput', false))

writetable(T, fullfile(EXPORTS_DIR, 'early_exit_results.csv'))

% example of early_exit pessimistic case
network_name = 'r_network_int48k_ext8k_res75k_public';
cid = 3;

sample1 = load(fullfile(RESULTS_DIR, [network_name '0.mat']));
sample2 = load(fullfile(RESULTS_DIR, [network_name '1.mat']));

l1 = sample1.output.c{cid}.fillin_tracker;
l2 = sample2.output.c{cid}.fillin_tracker;
best_elim = length(sample1.output.c{cid}.eliminated_nodes);
early_stop = find(sample2.output.c{cid}.fillin_tracker == 0, 1) - 1;

figure;
semilogy(1:length(l2), l2, '-b', 1:length(l1), l1, '--b', ...
    best_elim, l1(best_elim), 'ob', ...
    early_stop, l2(early_stop), 'xr', ...
    'MarkerSize', 8, 'MarkerFaceColor','auto');
legend('Funkcja kosztu symulacji (wczesne wyj¶cie)',...
    'Funkcja kosztu symulacji (bez wczesnego wyj¶cia)', ...
    'Minimum funkcji kosztu', ...
    'Punkt wczesnego zakoñczenia poszukiwañ');
print(fullfile(EXPORTS_DIR, 'ee_pessimistic.eps'), '-depsc')

% example of early_exit optimistic case
% example of early_exit optimistic case
network_name = 'network_c';
cid = 11;

sample1 = load(fullfile(RESULTS_DIR, [network_name '0.mat']));
sample2 = load(fullfile(RESULTS_DIR, [network_name '1.mat']));

l1 = sample1.output.c{cid}.fillin_tracker;
l2 = sample2.output.c{cid}.fillin_tracker;
best_elim = length(sample1.output.c{cid}.eliminated_nodes);
early_stop = find(sample2.output.c{cid}.fillin_tracker == 0, 1) - 1;

figure;
semilogy(1:length(l2), l2, '-b', 1:length(l1), l1, '--b', ...
    best_elim, l1(best_elim), 'ob', ...
    early_stop, l2(early_stop), 'xr', ...
    'MarkerSize', 8, 'MarkerFaceColor','auto');
legend('Funkcja kosztu symulacji (wczesne wyj¶cie)',...
    'Funkcja kosztu symulacji (bez wczesnego wyj¶cia)', ...
    'Minimum funkcji kosztu', ...
    'Punkt wczesnego zakoñczenia poszukiwañ');
print(fullfile(EXPORTS_DIR, 'ee_optimistic.eps'), '-depsc')
