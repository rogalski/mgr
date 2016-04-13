%#ok<*NOPTS>
clear all
close all
[G, is_ext_node] = load_mrewiens('lr_fake_disconnected');

previous_circuit_info = circuit_info(G, is_ext_node)
dotfiles.dump('1.dot', G, is_ext_node);
run_neato('1.dot');
tic
output = reducer(G, is_ext_node, struct);
toc
to_info = input_for_circuit_composite_info(output);
reduced_circuit_info = circuit_composite_info(to_info{:})

to_dump = input_for_dump(output);
dotfiles.dump_composite('2.dot', to_dump{:});
run_neato('2.dot');
