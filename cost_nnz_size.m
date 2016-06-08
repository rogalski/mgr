function [ c ] = cost_nnz_size( G )
% COUNT_RESISTORS Counts number of resistors in circuit described by G.
c = (nnz(triu(G, 1)) ^ 2) * length(G);
end
