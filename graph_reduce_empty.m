function [ out ] = graph_reduce_empty( G, is_ext_node, ~ )
out = struct;
out.G = G;
out.removed_nodes = [];
out.new_nodes = 1:length(G);
out.is_ext_node = is_ext_node;
