function [ c ] = count_resistors( G )
c = nnz(triu(G, 1));
end
