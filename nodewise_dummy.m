%% Internal node elimination procedure: Constrained AMD
% Inputs:
%  conn_comp_G: matrix to reduce
%  conn_comp_ExtNodes: vector of zeros / ones to denote terminals
% Outputs:
%  bestG
%  global_nodes_left: selecting vector
Perm = [setdiff(1:length(conn_comp_G), conn_comp_ExtNodes) conn_comp_ExtNodes];
nodewise__fixed_ordering;
