% NODEWISE_CAMD Nodewise elimination procedure: NESDIS + simple reordering
%
% See also NODEWISE_ABSTRACT, NESDIS.
function reduced_data = nodewise_nesdis_dummy( G, is_ext_node, options )
    p = nesdis(G);
    p_terminals = is_ext_node(p);
    Perm = [p(p_terminals==0) p(p_terminals==1)];
    
    reduced_data = struct;
    nodewise__fixed_ordering;
end
