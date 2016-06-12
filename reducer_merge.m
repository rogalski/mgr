function [G, is_ext_node, new_nodes] = reducer_merge( output )
%REDUCER_MERGE Merges reducer output (separate components info) tosingle
%circuit

Gn = cellfun(@(s) s.G, output.c, 'UniformOutput', false);
is_ext_noden = cellfun(@(s) s.is_ext_node, output.c, 'UniformOutput', false);
new_nodesn = cellfun(@(s) s.new_nodes, output.c, 'UniformOutput', false);
G = blkdiag(Gn{:});
is_ext_node = vertcat(is_ext_noden{:});
new_nodes = vertcat(new_nodesn{:});
end
