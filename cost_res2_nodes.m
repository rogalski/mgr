function [ c ] = cost_res2_nodes( G )
% COUNT_RESISTORS Counts number of resistors in circuit described by G.
c = (nnz(triu(G, 1)) ^ 2) * length(G);
end
