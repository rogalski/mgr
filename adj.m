function [ A ] = adj( G )
A = spones(G);
A(logical(speye(size(G)))) = 0;
end
