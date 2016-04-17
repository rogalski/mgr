%#ok<*NOPTS>
clear all %#ok<CLALL>
close all
[G, is_ext_node] = load_mrewiens('lr_fake1');

input_circuit_info = circuit_info(G, is_ext_node)

options = struct;
options.nodewise_algorithm = 'recursive_amd';
options.graph_algorithm = 'standard';

tic
output = reducer(G, is_ext_node, options)
output.options
toc

to_info = input_for_circuit_composite_info(output);
output_circuit_info = circuit_composite_info(to_info{:})

to_dump = input_for_dump(output);
netlists.dump_composite('output.cir', to_dump{:})

if (output.conn_components_count == 1)
    is_correct = check_reduction_correctness(G, is_ext_node, output)
end
