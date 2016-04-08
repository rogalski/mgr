function [ info ] = circuit_info( G, IsExtNode )
info = struct;
info.num_nodes = length(find(any(G,2)));
info.num_external = length(find(IsExtNode == 1));
info.num_internal = info.num_nodes - info.num_external;
info.num_resistors = count_resistors(G);
end
