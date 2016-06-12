function [ c ] = cost_res_nodes( G )
% COUNT_RESISTORS Counts number of resistors in circuit described by G.
c = nnz(triu(G, 1)) * length(G);
end
