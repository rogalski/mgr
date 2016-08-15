% Tests for graph_reduce

%% Test: no_ext_nodes
G = [2, -1, -1; -1, 2, -1; -1, -1, 2];
is_ext_node = [0, 0, 0];
out = graph_reduce(G, is_ext_node);
assert(isequal(out.G, []));
assert(isequal(out.removed_nodes, [1, 2, 3]));
assert(isequal(out.new_nodes, []));
assert(isequal(out.is_ext_node, []));

%% Test: dangling_network
G = [1, -1, 0, 0; -1 2 -1 0; 0, -1, 2, -1; 0, 0, -1, 1];
is_ext_node = [1, 1, 0, 0];
out = graph_reduce(G, is_ext_node);
assert(isequal(out.G, [1, -1 0; -1, 2, -1; 0, -1, 1]));
assert(isequal(out.removed_nodes, 4));
assert(isequal(out.new_nodes, [1, 2, 3]));
assert(isequal(out.is_ext_node, [1, 1, 0]));

%% Test: twoconn_component_artnodes
G = [
    1, -1,  0,  0,  0,  0;
    -1,  4, -1, -1, -1,  0;
    0, -1,  2,  0, -1,  0;
    0, -1,  0,  2, -1,  0;
    0, -1, -1, -1,  4, -1;
    0,  0,  0,  0, -1,  1;
    ];
is_ext_node = [1, 0, 0, 0, 0, 1];
out = graph_reduce(G, is_ext_node);
assert(isequal(out.G, [1, -1, 0, 0; -1, 3, -2, 0; 0, -2, 3, -1; 0, 0, -1, 1]));
assert(isequal(out.removed_nodes, [3, 4]));
assert(isequal(out.new_nodes, [1, 2, 5, 6]));
assert(isequal(out.is_ext_node, [1, 0, 0, 1]));
