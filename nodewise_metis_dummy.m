%% Internal node elimination procedure: METIS + Recursive approach
% This code eliminates nodes one-by-one, keeping track of system with 
% fewest resistors. If ordering hits terminal, recursive approach is used.
% Inputs:
%  conn_comp_G: matrix to reduce
%  conn_comp_ExtNodes: vector of zeros / ones to denote terminals
% Outputs:
%  bestG
%  global_nodes_left: selecting vector
mask = ~to_mask(conn_comp_ExtNodes, length(conn_comp_G));
abs_nodes_numbers = find(mask);
p = metisreorder(conn_comp_G(mask, mask));
Perm = [abs_nodes_numbers(p) conn_comp_ExtNodes];
nodewise__fixed_ordering;
