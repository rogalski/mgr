clear all
close all
CIRCUIT_NAME = 'lr_fake1'
tic
load_mrewiens
num_terminals = length(find(IsExtNode == 1))
num_nodes_prev = length(find(any(G,2)))
num_res_prev = count_resistors(G)
metisreorder(G)
IsExtNode
reducer
num_nodes_post = length(find(any(G,2)))
num_res_post = count_resistors(G)
toc
