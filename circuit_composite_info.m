function [ info ] = circuit_composite_info( varargin )
%CIRCUIT_COMPOSITE_INFO Computes stats for composite circuit (circuit
%partitioned to connected components);

num_circuits = nargin / 2;
infos = cell(num_circuits, 1);
for k = 1:num_circuits
    G = varargin{2*k-1};
    is_ext_node = varargin{2*k};
    infos{k} = circuit_info(G, is_ext_node);
    if infos{k}.num_conn_components > 1
        warning('Pair %d has more than one connected component', k)
    end
end

info = struct;
info.num_nodes = sum(cellfun(@(s) s.num_nodes, infos));
info.num_external = sum(cellfun(@(s) s.num_external, infos));
info.num_internal = sum(cellfun(@(s) s.num_internal, infos));
info.num_resistors = sum(cellfun(@(s) s.num_resistors, infos));
info.num_conn_components = sum(cellfun(@(s) s.num_conn_components, infos));

end
