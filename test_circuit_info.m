% Tests for circuit_info

%% Test: lr_test_two_connected
[G, is_ext_node] = load_mrewiens('lr_test_two_connected');
% dotfiles.dump('lr_test_two_connected.dot', G, is_ext_node);
% run_neato('lr_test_two_connected.dot')
info = circuit_info(G, is_ext_node);
assert(8 == info.num_nodes)
assert(4 == info.num_external)
assert(4 == info.num_internal)
assert(8 == info.num_resistors)
assert(2 == info.num_conn_components)

%% Test: empty_nodes_no_terminals
G = [1, -1, 0; -1 1 0; 0 0 0];
is_ext_node = [1, 1, 0];
% dotfiles.dump('empty_nodes_no_terminals.dot', G, is_ext_node);
% run_neato('empty_nodes_no_terminals.dot')
info = circuit_info(G, is_ext_node);
assert(2 == info.num_nodes)
assert(2 == info.num_external)
assert(0 == info.num_internal)
assert(1 == info.num_resistors)
assert(1 == info.num_conn_components)

%% Test: empty_nodes_with_terminal
G = [0, 0, 0, 0; 0, 0, 0, 0; 0, 0, -1, 1; 0, 0, 1, -1];
is_ext_node = [0, 1, 1, 0];
% dotfiles.dump('empty_nodes_with_terminal.dot', G, is_ext_node);
% run_neato('empty_nodes_with_terminal.dot')
info = circuit_info(G, is_ext_node);
assert(3 == info.num_nodes)
assert(2 == info.num_external)
assert(1 == info.num_internal)
assert(1 == info.num_resistors)
assert(2 == info.num_conn_components)

%% Test: composite
[G, is_ext_node] = load_mrewiens('lr_test_two_connected');
info = circuit_composite_info(G, is_ext_node, G, is_ext_node);
assert(16 == info.num_nodes)
assert(8 == info.num_external)
assert(8 == info.num_internal)
assert(16 == info.num_resistors)
assert(4 == info.num_conn_components)
