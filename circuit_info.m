function [ info ] = circuit_info( G, is_ext_node )
assert(size(G,1) == size(G,2))
assert(size(G,1) == length(is_ext_node))

non_empty_nodes = any(G,2);
empty_nodes = ~any(G,2);

s = sum(is_ext_node(empty_nodes));
info = struct;
info.num_nodes = length(G(non_empty_nodes, non_empty_nodes)) + s;
info.num_external = length(find(is_ext_node == 1));
info.num_internal = info.num_nodes - info.num_external;
info.num_resistors = count_resistors(G);
c = components(adj(G(non_empty_nodes, non_empty_nodes)));
if isempty(c)
    info.num_conn_components = 0;
else
    info.num_conn_components = max(c);
end
info.num_conn_components = info.num_conn_components + s;

end
