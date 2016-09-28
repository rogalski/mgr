close all;
testcases = dir(fullfile('test_suites', 'basic', '*.mat'));

% variants
tc_count = length(testcases);

RESULTS_DIR = fullfile('results', mfilename);
mkdir(RESULTS_DIR);
EXPORTS_DIR = fullfile('exports', mfilename);
mkdir(EXPORTS_DIR);

% run testcases
for f=testcases'
    fname = fullfile('test_suites', 'basic', f.name);
    load(fname, 'G', 'is_ext_node')
    
    dst_file = fullfile(RESULTS_DIR, f.name);
    if exist(dst_file, 'file')
        continue
    else
        f.name
        options = struct;
        options.verbose = 0;
        options.early_exit = 0;
        options.cost_function = @count_resistors;
        result_camd = nodewise_camd(G, is_ext_node, options);
        result_ramd = nodewise_amd_recursive(G, is_ext_node, options);
        save(dst_file, 'result_camd', 'result_ramd')
    end
end

disp PARSE

results = dir(fullfile(RESULTS_DIR, '*.mat'));

num_nodes_camd = nan(length(results), 1);
num_res_camd = nan(length(results), 1);
num_nodes_ramd = nan(length(results), 1);
num_res_ramd = nan(length(results), 1);
equivalent = nan(length(results), 1);
almost_equivalent = nan(length(results), 1);
camd_better = nan(length(results), 1);
ramd_better = nan(length(results), 1);

idx = 0;
for f=results'
    idx = idx+1;
    dst_file = fullfile(RESULTS_DIR, f.name);
    load(dst_file, 'result_camd', 'result_ramd');
    info_camd = circuit_info(result_camd.G, result_camd.is_ext_node);
    info_ramd = circuit_info(result_ramd.G, result_ramd.is_ext_node);
    
    num_nodes_camd(idx) = info_camd.num_nodes;
    num_res_camd(idx) = info_camd.num_resistors;
    num_nodes_ramd(idx) = info_ramd.num_nodes;
    num_res_ramd(idx) = info_ramd.num_resistors;
    equivalent(idx) = isequal(info_camd, info_ramd);
    camd_better(idx) = num_res_camd(idx) < 0.9 * num_res_ramd(idx);
    ramd_better(idx) = num_res_ramd(idx) < 0.9 * num_res_camd(idx);
    almost_equivalent(idx) = ~equivalent(idx) && ~ramd_better(idx) && ~camd_better(idx);
end

T = table(num_nodes_camd, num_res_camd, num_nodes_ramd, num_res_ramd, equivalent, almost_equivalent, camd_better, ramd_better);
T.Properties.RowNames = arrayfun(@num2str, 1:length(results), 'unif', 0);

writetable(T, fullfile(EXPORTS_DIR, 'raw_results.csv'), 'WriteRowNames',true)
