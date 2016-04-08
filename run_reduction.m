clear all
close all
CIRCUIT_NAME = 'r_network_int48k_ext8k_res75k_public'
load_rommes
circuit_info(G, IsExtNode)
% netlists.dump('1.cir', G, ExtNodes);
% dotfiles.dump('1.dot', G, ExtNodes, 1);
tic
reducer;
toc
circuit_info(G, IsExtNode)
% dotfiles.dump('2.dot', G, ExtNodes, 1);
