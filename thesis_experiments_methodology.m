[G, is_ext_node] = load_rommes('r_network_int46k_ext8k_res67k_public');
c = components(adj(G));
ci = 1400;
Gn = G(c==ci, c==ci);
is_ext_noden = is_ext_node(c==ci);

N = 20;  % number of connected components to create in first step
n = length(Gn);

% Create huge matrix of N connected components
GnList = repmat({Gn}, 1, N);
G1 = blkdiag(GnList{:});
is_ext_node1 = repmat(is_ext_noden, [N 1]);

% Add stamps to conencted all resistors
G2 = G1;
for i=1:(N-1)
    x = [i*n, i*n+1, i*n, i*n+1];
    y = [i*n, i*n, i*n+1, i*n+1];
    v = [1 -1 -1 1];
    S = sparse(x, y, v, N*n, N*n);
    G2 = G2 + S;
end

options = struct;
options.nodewise_algorithm = 'camd';
options.graph_algorithm = 'none';
options.cost_function = @count_resistors;
options.verbose = 0;
options.auto_save = 0;

tic
output1 = reducer(G1, is_ext_node1, options);
toc

tic
output2 = reducer(G2, is_ext_node1, options);
toc

info1_pre = circuit_info(G1, is_ext_node1)
info2_pre = circuit_info(G2, is_ext_node1)

i1 = input_for_circuit_composite_info(output1);
i2 = input_for_circuit_composite_info(output2);

info1post = circuit_composite_info(i1{:})
info2_post = circuit_composite_info(i2{:})
