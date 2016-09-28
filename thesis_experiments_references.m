% Runs reference (non-reduced) measurements for

testcases = dir(fullfile('test_suites', 'big', '*.mat'));
tc_count = length(testcases);

RESULTS_DIR = fullfile('results', 'reference');
mkdir(RESULTS_DIR);

for f = testcases'
    fname = fullfile('test_suites', 'big', f.name);
    [tc_dir, tc_name, ext] = fileparts(f.name);
    output_filename = @(suffix) fullfile(RESULTS_DIR, [tc_name suffix]);
    
    if exist(output_filename(['.mat']), 'file') == 2
        continue
    end
    tc_name
    load(fname);
    
    if ~exist(output_filename('.cir'), 'file')
        netlists.dump(output_filename('.cir'), G, is_ext_node);
    end
    if ~exist(output_filename('.log'), 'file')
        ngspice.run(output_filename('.cir'));
    end
end
