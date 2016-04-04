function [ A ] = adj( G )
    A = G;
    A(logical(speye(size(G)))) = 0;
    A(~A) = 1;
end
