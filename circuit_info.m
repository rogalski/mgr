function [ info ] = circuit_info( G, IsExtNode )
non_empty_columns = find(any(G,2));

info = struct;
info.num_nodes = length(non_empty_columns);
info.num_external = length(find(IsExtNode == 1));
info.num_internal = info.num_nodes - info.num_external;
info.num_resistors = count_resistors(G);
info.num_conn_components = max(components(adj(G(non_empty_columns, non_empty_columns))));
end
