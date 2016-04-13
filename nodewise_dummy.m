% NODEWISE_DUMMY Nodewise elimination procedure: without smart ordering.
%
% See also NODEWISE_ABSTRACT.
function reduced_data = nodewise_dummy( G, is_ext_node, ~ )
    p = metis(G);
    p_terminals = is_ext_node(p);
    Perm = [p(p_terminals==0) p(p_terminals==1)];

    reduced_data = struct;
    nodewise__fixed_ordering;
end
