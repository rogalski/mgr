%% Internal node elimination procedure: Constrained AMD
% Inputs:
%  conn_comp_G: matrix to reduce
%  conn_comp_ExtNodes: vector of zeros / ones to denote terminals
% Outputs:
%  bestG
%  global_nodes_left: selecting vector
constrains = ones(1, length(conn_comp_G));
constrains(conn_comp_ExtNodes) = 2;
Perm = camd(conn_comp_G, camd, constrains);

nodewise__fixed_ordering;
