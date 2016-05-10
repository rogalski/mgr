%#ok<*NOPTS>
clear all %#ok<CLALL>
close all
[G, is_ext_node] = load_mrewiens('lr_fake1');

input_circuit_info = circuit_info(G, is_ext_node)

options = struct;
options.nodewise_algorithm = 'camd';
options.graph_algorithm = 'standard';
options.cost_function = @count_resistors;
options.verbose = 1;
options.auto_save = 0;

tic
output = reducer(G, is_ext_node, options)
output.options
toc

to_info = input_for_circuit_composite_info(output);
output_circuit_info = circuit_composite_info(to_info{:})
