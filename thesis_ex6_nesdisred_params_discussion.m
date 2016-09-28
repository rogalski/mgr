close all;
testcases = dir(fullfile('test_suites', 'basic', '*.mat'));
START = 50;

% assert starting point is ok
fname = fullfile('test_suites', 'basic', testcases(START-1).name);
load(fname, 'G', 'is_ext_node')
assert(length(G)<1000)
fname = fullfile('test_suites', 'basic', testcases(START).name);
load(fname, 'G', 'is_ext_node')
assert(length(G)>=1000)


testcases = testcases(START:end);

% variants
variants = [200:200:1000 inf];
tc_count = length(testcases);

RESULTS_DIR = fullfile('results', mfilename);
mkdir(RESULTS_DIR);
EXPORTS_DIR = fullfile('exports', mfilename);
mkdir(EXPORTS_DIR);

% run testcases
for f=testcases'
    f.name
    fname = fullfile('test_suites', 'basic', f.name);
    load(fname, 'G', 'is_ext_node')
    
    dst_dir = fullfile(RESULTS_DIR, f.name);
    for v=variants
        dst_file = fullfile(dst_dir, [num2str(v) '.mat']);
        if exist(dst_file, 'file')
            continue
        else
            options = struct;
            options.verbose = 0;
            options.early_exit = 0;
            options.cost_function = @count_resistors;
            options.nesdis_opts = [v 0 1 0];
            result = nodeelim_nesdis_camd(G, is_ext_node, options);
            mkdir(dst_dir);
            save(dst_file, 'result')
        end
    end
end


results = dir(fullfile(RESULTS_DIR, '*.mat'));
num_res = nan(length(results), length(variants));
num_nodes = nan(length(results), length(variants));
labels = cell(length(results), 1);

disp ---

idx = 0;
ticks = {};
for f=testcases'
    fname = f.name;
    idx = idx+1;
    dst_dir = fullfile(RESULTS_DIR, fname);
    for v=variants
        dst_file = fullfile(dst_dir, [num2str(v) '.mat']);
        load(dst_file, 'result');
        i = circuit_info(result.G, result.is_ext_node);
        num_res(idx,variants==v) = i.num_resistors;
        num_nodes(idx,variants==v) = i.num_nodes;
        % ticks{idx,variants==v} = ['R:' num2str(i.num_resistors) ' T:' num2str(i.num_nodes) ' I:' num2str(i.num_internal) ' E:' num2str(i.num_external), ' AvgDeg:', num2str(mean(degrees(result.G)))];
        % ticks{idx,variants==v} = ['R:' num2str(i.num_resistors) ' I:' num2str(i.num_internal) ' E:' num2str(i.num_external), ' AvgDeg:', num2str(mean(degrees(result.G)))];
        % ticks{idx,variants==v} = ['R:' num2str(i.num_resistors) ' I:' num2str(i.num_internal) ' E:' num2str(i.num_external), ' density:', num2str(nnz(result.G)/numel(result.G))];
        labels(idx) = {fname};
    end
end

% kind of ugly, but I don't know how to achieve nice-formatted headers yet

nres_200 = num_res(:, 1);
nres_400 = num_res(:, 2);
nres_600 = num_res(:, 3);
nres_800 = num_res(:, 4);
nres_1k = num_res(:, 5);
nres_camd = num_res(:, 6);


nnode_200 = num_nodes(:, 1);
nnode_400 = num_nodes(:, 2);
nnode_600 = num_nodes(:, 3);
nnode_800 = num_nodes(:, 4);
nnode_1k = num_nodes(:, 5);
nnode_camd = num_nodes(:, 6);

t = table(nres_200, nres_400, nres_600, nres_800, nres_1k, nres_camd, ...
    nnode_200, nnode_400, nnode_600, nnode_800, nnode_1k, nnode_camd);
t.Properties.RowNames = arrayfun(@num2str, START:START+numel(nres_200)-1, 'unif', 0);
writetable(t, fullfile(EXPORTS_DIR, 'raw_results.csv'), 'writerownames', 1)

% some statistics
num_res_min_nesdisred = min(num_res, [], 2);
is_smallest_nres = num_res <= repmat(num_res_min_nesdisred, 1, length(variants));
is_smallest_nres_within_10percent = num_res <= repmat(num_res_min_nesdisred * 1.1, 1, length(variants));

csvwrite(fullfile(EXPORTS_DIR, 'is_smallest_nres.csv'), sum(is_smallest_nres));
csvwrite(fullfile(EXPORTS_DIR, 'is_smallest_nres_within_10percent.csv'), sum(is_smallest_nres_within_10percent));

num_node_min_nesdisred = min(num_nodes, [], 2);
is_smallest_nnode = num_nodes <= repmat(num_node_min_nesdisred, 1, length(variants));
is_smallest_nnode_within_10percent = num_nodes <= repmat(num_node_min_nesdisred * 1.1, 1, length(variants));
csvwrite(fullfile(EXPORTS_DIR, 'is_smallest_nnode.csv'), sum(is_smallest_nnode));
csvwrite(fullfile(EXPORTS_DIR, 'is_smallest_nnode_within_10percent.csv'), sum(is_smallest_nnode_within_10percent));

csvwrite(fullfile(EXPORTS_DIR, 'sum_num_res.csv'), sum(num_res));
csvwrite(fullfile(EXPORTS_DIR, 'sum_num_nodes.csv'), sum(num_nodes));
