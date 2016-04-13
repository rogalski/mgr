% NODEWISE_CAMD Nodewise elimination procedure: METIS + simple reordering
%
% See also NODEWISE_ABSTRACT, METIS.
function reduced_data = nodewise_metis_dummy( G, is_ext_node, options )
    p = metis(G);
    p_terminals = is_ext_node(p);
    Perm = [p(p_terminals==0) p(p_terminals==1)];

    reduced_data = struct;
    nodewise__fixed_ordering;
end
