%#ok<*NOPTS>
clear all %#ok<CLALL>
close all
[G, is_ext_node] = load_mrewiens('lr_fake1');

input_circuit_info = circuit_info(G, is_ext_node)

tic
output = reducer(G, is_ext_node, struct('nodewise_algorithm', 'nesdis'))
toc

to_info = input_for_circuit_composite_info(output);
output_circuit_info = circuit_composite_info(to_info{:})

to_dump = input_for_dump(output);
netlists.dump_composite('output.cir', to_dump{:})
