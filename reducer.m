function out = reducer( G, is_ext_node, options )
% REDUCER Performs analysis and reduction of G network.
% Input:
%   G - conductance matrix
%   IsExtNode - mask vector
% Output:
%   TBD
assert(length(is_ext_node) == size(G, 1));

A = adj(G);
out = struct;

% 1. Compute connected components Gi of G
connected_components = components(A);

unique_connected_components = unique(connected_components);
connected_components_count = length(unique_connected_components);

out.conn_components_count = connected_components_count;
out.nodewise_processing_times = cell(connected_components_count, 1);
out.subdata = cell(connected_components_count, 1);

for conn_comp_i = 1:connected_components_count
    conn_comp_id = unique_connected_components(conn_comp_i);
    conn_comp_sel = (connected_components == conn_comp_id);
    
    conn_comp_A = A(conn_comp_sel, conn_comp_sel);
    conn_comp_G = G(conn_comp_sel, conn_comp_sel);
    conn_comp_is_ext_node = is_ext_node(conn_comp_sel);
    global_context = find(conn_comp_sel);

    after_graph = graph_reduce(conn_comp_G, conn_comp_is_ext_node, conn_comp_A);
    
    switch options.reorder_strategy
        case 'none'
            nodewise_reductor = @nodewise_dummy;
        case 'nesdis'
            nodewise_reductor = @nodewise_nesdis_dummy;
        otherwise
            nodewise_reductor = @nodewise_camd;
    end
    
    % Eliminate nodes ne-by-one
    timer = tic;
    d = nodewise_reductor( after_graph.G, after_graph.is_ext_node, struct );
    out.nodewise_processing_times{conn_comp_i} = toc(timer); 

    d.new_nodes = global_context(after_graph.new_nodes(d.new_nodes));
    out.subdata{conn_comp_i} = d;
end
