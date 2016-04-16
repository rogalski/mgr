function out = reducer( G, is_ext_node, options )
% REDUCER Performs analysis and reduction of G network.
% Input:
%   G - conductance matrix
%   IsExtNode - mask vector
% Output:
%   out.options - options used to this run
%   out.conn_components_count - total count of connected components in G
%   out.c - cells of reduction results for each connected component

assert(length(is_ext_node) == size(G, 1));

A = adj(G);
out = struct;

options = build_reducer_options(options);


% 1. Compute connected components Gi of G
connected_components = components(A);

unique_connected_components = unique(connected_components);
connected_components_count = length(unique_connected_components);

out.conn_components_count = connected_components_count;
out.c = cell(connected_components_count, 1);

for conn_comp_i = 1:connected_components_count
    conn_comp_id = unique_connected_components(conn_comp_i);
    conn_comp_sel = (connected_components == conn_comp_id);
    
    conn_comp_A = A(conn_comp_sel, conn_comp_sel);
    conn_comp_G = G(conn_comp_sel, conn_comp_sel);
    conn_comp_is_ext_node = is_ext_node(conn_comp_sel);
    global_context = find(conn_comp_sel);

    graph_timer = tic;
    after_graph = options.graph_algorithm(conn_comp_G,conn_comp_is_ext_node, conn_comp_A);
    graph_processing_time = toc(graph_timer);
    
    % Eliminate nodes ne-by-one
    nodewise_timer = tic;
    d = options.nodewise_algorithm(after_graph.G, after_graph.is_ext_node, struct);
    nodewise_processing_time = toc(nodewise_timer); 

    d.new_nodes = global_context(after_graph.new_nodes(d.new_nodes));
    d.graph_processing_time = graph_processing_time;
    d.nodewise_processing_time = nodewise_processing_time;
    out.c{conn_comp_i} = d;
end
out.options = options;
