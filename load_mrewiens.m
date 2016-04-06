if ~exist('MRewiensTerminals', 'var')
    MRewiensTerminals = dlmread(['circuits/mrewiens/' CIRCUIT_NAME '/out_term.txt']);
end
if ~exist('MRewiensEdges', 'var')
    MRewiensEdges = dlmread(['circuits/mrewiens/' CIRCUIT_NAME '/out_edges.txt']);
end
m = max(max(MRewiensEdges));
if ~exist('G', 'var')
    % NA Matrix
    G = sparse([MRewiensEdges(:, 1); MRewiensEdges(:, 2); (1:m)'], ...
                [MRewiensEdges(:, 2); MRewiensEdges(:,1 ); (1:m)'], ...
                [-1 * ones(1, 2*length(MRewiensEdges)) ones(1, m)], ...
                m, m, 32 * m);    
    G(logical(speye(size(G)))) = 1 - sum(G, 2);
end
if ~exist('A', 'var')
    % Adjacency Matrix
    m = max(max(MRewiensEdges));
    A = sparse([MRewiensEdges(:, 1); MRewiensEdges(:, 2);], ...
               [MRewiensEdges(:, 2); MRewiensEdges(:,1 );], ...
               ones(1, numel(MRewiensEdges)));    
end
IsExtNode = zeros(1, m);
IsExtNode(MRewiensTerminals) = 1;
ExtNodes = MRewiensTerminals;
