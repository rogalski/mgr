% Test matrix definition - test cases
% See create_test_suite_basic.
testcases = dir(fullfile('test_suites', 'basic', '*.mat'));
testcases = testcases(4:end);
tc_count = length(testcases);

% Test matrix definition - reduction params
testMatrix_costFuncs_empty = {[]};
testMatrix_costFuncs = {@count_resistors, @cost_nnz_size};

testMatrix_nesDisOpts = {[5 0 1 0], [10 0 1 0], [20 0 1 0], [50 0 1 0], [100 0 1 0], [200 0 1 0]};
testMatrix_emptyNesDisOpts = {[]};

testMatrix = [
    allcomb({'camd', 'recursive_amd'}, testMatrix_costFuncs, testMatrix_emptyNesDisOpts);
    allcomb({'nesdis_dummy'}, testMatrix_costFuncs_empty, testMatrix_nesDisOpts);
    allcomb({'nesdis_camd'}, testMatrix_costFuncs, testMatrix_nesDisOpts);
];

mkdir('results')
for c = testMatrix'
    elimScheme = c{1};
    costFunc = c{2};
    nesdisOpts = c{3};
    
    if isempty(costFunc) costFuncName = ''; else costFuncName = func2str(costFunc); end
    if isempty(nesdisOpts) nesDisSuffix = ''; else nesDisSuffix = num2str(nesdisOpts(1)); end
    results_group = strjoin({elimScheme costFuncName num2str(nesDisSuffix)}, '-')
    
    result_dir = fullfile('results', results_group);
    mkdir(result_dir);
    
    % build struct
    options = struct;
    options.verbose = 0;
    options.nodewise_algorithm = elimScheme;
    options.graph_algorithm = 'standard';
    if ~isempty(costFunc)
        options.cost_function = costFunc;
    end
    if ~isempty(costFunc)
        options.nesdis_opts = nesdisOpts;
    end
    options

    % Dummy throwaway run to allow JIT to do it's magic
    disp('Warmup run')
    N = 8;
    G = gallery('tridiag', N, -1, 2, -1);
    G(1,1) = 1;
    G(N,N) = 1;
    is_ext_node = [1 zeros(1, N-2) 1]';
    reducer(G, is_ext_node, options);
    
    % Run actual testcases
    for f = testcases'
        fname = fullfile('test_suites', 'basic', f.name);
        [tc_dir, tc_name, ext] = fileparts(f.name);
        dst = fullfile(result_dir, [tc_name '.mat']);
        if exist(dst, 'file') == 2
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

        dst = fullfile(result_dir, [tc_name '.mat']);
        save(dst, 'input_circuit_info', 'output', 'output_circuit_info', 'G', 'is_ext_node');
    end
end
