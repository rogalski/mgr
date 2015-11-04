% Inputs:
% G: Conductance matrix
% I: Currents injected to nodes
% Output:
% V: node voltages
G = [2, -1, 0; -1 3 -1; 0 -1 2];
I = [0, 0, 1]';

P = amd(G);
PT = zeros(1:lenghth(P));
PT(P) = 1:length(P); % inverse permutation vector

Gp = G(P,P);
Ip = I(P);

% Naive approach, just to verify
VNaive = G\I;

% FastR approach
L = chol(Gp);
x = (L') \ Ip;
V = (L) \ x;

V = V(PT);
