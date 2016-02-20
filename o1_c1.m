o1_base_load;

node_sizes = zeros(1,6);
edge_sizes = zeros(1,6);
times = zeros(1,6);

to_run = [1,2,3,6];

for k= [1,2,3,6]
    O1_C_ID = k;
    o1_base_subcircuit;

    n = length(subC);
    e = nnz(tril(subC));
    t = length(subCTerminals);
    disp('Node count')
    disp(n)
    disp('Edge count')
    disp(e)
    disp('Terminal count')
    disp(t)
    
    G = subC;
    Terminals = subCTerminals;
    node_sizes(k) = n;
    edge_sizes(k) = e;
    tic
    reducer;
    elapsedTime = toc;
    times(k) = elapsedTime;
end

bar(node_sizes(to_run) + edge_sizes(to_run), times(to_run));
polyfit(node_sizes(to_run) + edge_sizes(to_run), times(to_run), 2)
