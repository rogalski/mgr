%% Known reorderings showcase
% This file is here just to show up what reordering techniques are
% implemented  / known in this codebase for now.

%% Input data preparation
load('third_party/SuiteSparse/UFget/mat/HB/494_bus.mat')

%% Original matrix
A = Problem.A;
spy(A);

%% Approximate minimum degree - amd()
perm_amd = amd(A);
spy(A(perm_amd, perm_amd));

%% Constrained approximate minimum degree - camd() (w/o constrains)
perm_camd = camd(A);
spy(A(perm_camd, perm_camd));

%% Constrained approximate minimum degree - camd() (w/ constrains)
constrains = 1 + (rand(1, length(A)) < 0.3);
perm_camd_c = camd(A, 1, constrains);
spy(A(perm_camd_c, perm_camd_c));

%% Nested dissections - METIS NodeND
perm_metis = metisreorder(A);
spy(A(perm_metis, perm_metis));
