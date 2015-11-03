% Input
G = [2, -1, 0; -1 3 -1; 0 -1 2];
I = [1, 0, 0]';

P = amd(G); % permutation vector
PT(P) = 1:length(P); % inverse permutation vector
% Permuted input
Gp = G(P,P);
Ip = I(P);

% Naive approach, just to verify
v = G\I

% FastR approach
L = chol(Gp);
x = (L') \ Ip;
v2 = (L) \ x;

v2 = v2(PT)
