% NODEWISE_CAMD Nodewise elimination procedure: Constrained AMD
%
% See also NODEWISE_ABSTRACT.
function reduced_data = nodewise_camd( G, is_ext_node, options ) %#ok<INUSD>
    constrains = ones(1, length(G));
    if nnz(is_ext_node) < length(G)
        constrains(logical(is_ext_node)) = 2;
    end
    Perm = camd(G, camd, constrains);

    reduced_data = struct;
    nodewise__fixed_ordering;

end
