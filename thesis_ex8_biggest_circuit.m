close all;
LOADER = @load_mrewiens;
CIRCUIT_NAME = 'o1';

RESULTS_DIR = fullfile('results', mfilename);
mkdir(RESULTS_DIR);
EXPORTS_DIR = fullfile('exports', mfilename);
mkdir(EXPORTS_DIR);

dst_file = fullfile(RESULTS_DIR, [CIRCUIT_NAME '.mat']);
netlist_org_file = fullfile(RESULTS_DIR, 'org.cir');
netlist_red_file = fullfile(RESULTS_DIR, 'red.cir');
if ~exist(dst_file, 'file')
    [G, is_ext_node] = LOADER(CIRCUIT_NAME);
    options = struct;
    options.verbose = 0;
    options.early_exit = 1;
    options.cost_function = @cost_res2_nodes;
    options.nodewise_algorithm = 'nesdis_camd';
    options.nesdis_opts = [1000, 0, 1, 0];
    disp warmup
    reducer_warmup(options);
    disp done
    t = tic;
    result = reducer(G, is_ext_node, options);
    time = toc(t);
    save(dst_file, 'result', 'time', '-v7.3')
    dump_data = input_for_dump(result);
    netlists.dump_composite(netlist_red_file, dump_data{:});
else
    load(dst_file, 'result', 'time')
end
[G, is_ext_node] = LOADER(CIRCUIT_NAME);
netlists.dump(netlist_org_file, G, is_ext_node);
