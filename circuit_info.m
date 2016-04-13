function [ info ] = circuit_info( G, is_ext_node )
assert(size(G,1) == size(G,2))
assert(size(G,1) == length(is_ext_node))
non_empty_columns = find(any(G,2));

info = struct;
info.num_nodes = length(non_empty_columns);
info.num_external = length(find(is_ext_node == 1));
info.num_internal = info.num_nodes - info.num_external;
info.num_resistors = count_resistors(G);
info.num_conn_components = max(components(adj(G(non_empty_columns, non_empty_columns))));
end
