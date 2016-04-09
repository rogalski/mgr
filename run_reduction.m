%#ok<*NOPTS>
clear all
close all
CIRCUIT_NAME = 'r_network_int46k_ext8k_res67k_public'
load_rommes
previous_circuit_info = circuit_info(G, IsExtNode)
% netlists.dump('1.cir', G, ExtNodes);
% dotfiles.dump('1.dot', G, ExtNodes, 1);
tic
reducer;
toc
reduced_circuit_info = circuit_info(G, IsExtNode)
% dotfiles.dump('2.dot', G, ExtNodes, 1);
