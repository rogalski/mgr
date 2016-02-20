if ~exist('O1Terminals', 'var')
    O1Terminals = dlmread('o1/out_term.txt');
end
if ~exist('O1Edges', 'var')
    O1Edges = dlmread('o1/out_edges.txt');
end
if ~exist('O1', 'var')
    O1 = sparse([O1Edges(:, 1) O1Edges(:, 2)], ...
                [O1Edges(:, 2) O1Edges(:,1 )], ...
                ones(1, 2*length(O1Edges)));
end
if ~exist('O1Components', 'var')
    O1Components = components(O1);  % connected components of graph
end
