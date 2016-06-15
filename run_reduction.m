%#ok<*NOPTS>
% clear all %#ok<CLALL>
close all

options = struct;
options.nodewise_algorithm = 'camd';
options.graph_algorithm = 'standard';
% options.cost_function = @count_resistors;
options.nesdis_opts = [param 0 1 0];
options.verbose = 0;

tic
output = reducer(G, is_ext_node, options)
output.options;
toc

to_info = input_for_circuit_composite_info(output);
output_circuit_info = circuit_composite_info(to_info{:})

if output_circuit_info.num_conn_components == 1
   t1 = find(is_ext_node, 1);
   G(t1, t1) = G(t1, t1) + 1;
   tn1 = find(output.c{1}.new_nodes == t1);
   output.c{1}.G(tn1, tn1) = output.c{1}.G(tn1, tn1) + 1;
   check_reduction_correctness(G, is_ext_node, output.c{1}.G, output.c{1}.new_nodes); 
end

to_dump = input_for_dump(output);
netlists.dump_composite([circuit_name '_' num2str(param) '.cir'], to_dump{:})
