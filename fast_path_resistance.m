function [ R ] = fast_path_resistance( L, t1, t2 )
%FAST_PATH_RESISTANCE Computes path resistance based on Rommes and
%Schilders algorithm
% L - lower Choelsky decomposition 
% t1, t2 - temrinal numbers or vectors

if all(size(t1) == 1)
    e1 = zeros(length(L), 1);
    e2(t1) = 1;
else
    e1 = t1';
end

if all(size(t2) == 1)
    e1 = zeros(length(L), 1);
    e2(t2) = 1;
else
    e2 = t2';
end

u = L\(e1-e2);
R = u'*u;
end
