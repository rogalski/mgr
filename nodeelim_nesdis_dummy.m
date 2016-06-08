% NODEWISE_NESDIS_DUMMY
% Custom reduction scheme developed as a part of this master's thesis.
% Approach is inspired by nested dissection fill-in reduction algorithm,
% but takes into consideration
%
% Steps
% 1. Bisect graph to retrieve good (small) separation trees. Mark
% separators as nodes to avoid reduction.
% 2. Reduce each leaf by computing Schur complement for leaf and all of its
% parents (all up to root). Keep separators and external nodes.
%
% See also NODEWISE_ABSTRACT, NESDIS.
function reduced_data = nodeelim_nesdis_dummy( G, is_ext_node, options )
    if ~isfield(options, 'nesdis_opts')
        options.nesdis_opts = [];
    end
    [~, cp, cmember] = nesdis(G, 'sym', options.nesdis_opts);
    
    % get tree leaves
    [~, y] = treelayout(cp);
    leaves = find(y == min(y));
    
    % reduce each leaf
    for n=1:length(leaves)
        if options.verbose
            fprintf('Reduce leaf; %i/%i\n', n, length(leaves))
        end
        leaf_id = leaves(n);
        leaf_nodes = (cmember == leaf_id);
        
        % get all parents of binary tree leaf
        parents = zeros(1, length(y));
        last_parent = leaf_id;
        k = 0;
        while last_parent ~= 0
            k = k+1;
            last_parent = cp(last_parent);
            parents(k) = last_parent;
        end
        parent_nodes = (ismember(cmember, parents));

        leaf_nodes_ints = find(leaf_nodes);
        parent_nodes_ints = find(parent_nodes);

        % subscript G
        leaf_all_nodes = [leaf_nodes_ints parent_nodes_ints];
        leafG = G(leaf_all_nodes, leaf_all_nodes);

        % apply adjustments for separator connectivity outside of leaf
        not_current_nodes = ~(leaf_nodes | parent_nodes);
        separator_connections_compensation = sum(G(leaf_all_nodes, :), 2) - sum(G(leaf_all_nodes, not_current_nodes), 2);
        leafG(1:length(leafG)+1:end) = leafG(1:length(leafG)+1:end) - separator_connections_compensation';

        % compute Schur complement for reduction process
        to_keep = [is_ext_node(leaf_nodes_ints)' ones(1, length(parent_nodes_ints))];
        to_keep = logical(to_keep);
        to_remove = ~to_keep;

        G11 = leafG(to_keep, to_keep);
        G12 = leafG(to_keep, to_remove);
        G22 = leafG(to_remove, to_remove);

        Gred = G11-(G12*(G22\(G12')));

        % re-apply adjustments for separator connectivity outside of leaf
        Gred(1:length(Gred)+1:end) = Gred(1:length(Gred)+1:end) + separator_connections_compensation(to_keep)';
        
        % replace new data
        G(leaf_all_nodes, leaf_all_nodes) = 0;
        G(leaf_all_nodes(to_keep), leaf_all_nodes(to_keep)) = Gred;
    
    % TODO: get rid of these empty rows and cols?
    % Live updates of sparse structure are fairly costly
    % Maybe partial results may be held in different data structure
    
    non_empty_nodes = any(G,2);
    new_nodes = 1:length(G);
    new_nodes = new_nodes(non_empty_nodes);

    reduced_data.G = G(non_empty_nodes, non_empty_nodes);
    reduced_data.new_nodes = new_nodes;
    reduced_data.is_ext_node = is_ext_node(non_empty_nodes);
    reduced_data.eliminated_nodes = [];
    reduced_data.early_exit = 0;
    reduced_data.fillin_tracker = [];
    end
end
