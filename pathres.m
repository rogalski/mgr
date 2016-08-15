% Inputs:
% G: conductance matrix
% ea, eb: a-th and b-th unit vector
% Output:
% Rab = effective resistance between nodes a and b
G = [2, -1, 0; -1 3 -1; 0 -1 2];
ea = [0, 0, 1]';
eb = [0, 1, 0]';

P = amd(G);
PT = zeros(1:length(P));
PT(P) = 1:length(P);

Gp = G(P, P);
eap = ea(P);
ebp = eb(P);

L = chol(Gp, 'lower');
u = L\(eap-ebp);
Rab = u'*u
