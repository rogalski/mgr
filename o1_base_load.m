if ~exist('O1Terminals', 'var')
    O1Terminals = dlmread([o_dir '/out_term.txt']);
end
if ~exist('O1Edges', 'var')
    O1Edges = dlmread([o_dir '/out_edges.txt']);
end
if ~exist('O1', 'var')
    %{
    % Graph adjacency matrix
    O1 = sparse([O1Edges(:, 1) O1Edges(:, 2)], ...
                [O1Edges(:, 2) O1Edges(:,1 )], ...
                ones(1, 2*length(O1Edges)));
    %}

    % NA Matrix
    m = max(max(O1Edges));
    O1 = sparse([O1Edges(:, 1); O1Edges(:, 2); (1:m)'], ...
                [O1Edges(:, 2); O1Edges(:,1 ); (1:m)'], ...
                [-1 * ones(1, 2*length(O1Edges)) ones(1, m)]);    
    O1(logical(speye(size(O1)))) = 1 - sum(O1, 2);
    % Make circuit positive definite - add huge resistor to one of ports
    % FirstTerminal = O1Terminals(1);
    % O1(FirstTerminal, FirstTerminal) = O1(FirstTerminal, FirstTerminal) + 0.0001;
end
if ~exist('O1Components', 'var')
    O1Components = components(O1);  % connected components of graph
end
