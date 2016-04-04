clear all
close all
CIRCUIT_NAME = 'r_network_int46k_ext8k_res67k_public'
tic
load_rommes
netlists.dump('run_in.cir', G);
reducer
netlists.dump('run_out.cir', G);
toc
