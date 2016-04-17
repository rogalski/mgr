function [ c ] = count_resistors( G )
% COUNT_RESISTORS Counts number of resistors in circuit described by G.
c = nnz(triu(G, 1));
end
