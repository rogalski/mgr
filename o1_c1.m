o_dir = 'o1';
o1_base_load;
to_run = 3;
times = zeros(size(to_run));
edges = zeros(size(to_run));
nodes = zeros(size(to_run));
terminals = zeros(size(to_run));

for circuit=1:numel(to_run)
    O1_C_ID = to_run(circuit);
    o1_base_subcircuit;
    nodes(circuit) = length(subC);
    edges(circuit) = nnz(tril(subC));
    terminals(circuit) = length(subCTerminals);
    G = subC;
    Terminals = subCTerminals;
    tic
    reducer;
    elapsed_time = toc;
    times(circuit) = elapsed_time;
end
