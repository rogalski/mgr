function [G, is_ext_node] = load_mrewiens(name)
mrewiens_terminals = dlmread(['circuits/mrewiens/' name '/out_term.txt']);
mrewiens_edges = dlmread(['circuits/mrewiens/' name '/out_edges.txt']);
m = max(max(mrewiens_edges));
G = sparse([mrewiens_edges(:, 1); mrewiens_edges(:, 2); (1:m)'], ...
    [mrewiens_edges(:, 2); mrewiens_edges(:,1 ); (1:m)'], ...
    [-1 * ones(1, 2*length(mrewiens_edges)) ones(1, m)], ...
    m, m, 32 * m);
G(logical(speye(size(G)))) = 1 - sum(G, 2);
is_ext_node = zeros(m, 1);
is_ext_node(mrewiens_terminals) = 1;
end
