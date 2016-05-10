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

options = build_reducer_options(options)
try
    load(options.output_file, 'out')
catch
    out = struct;
    out.options = options;
    % 1. Compute connected components Gi of G
    out.G = G;
    out.is_ext_node = G;
    out.A = adj(G);
    out.components = components(out.A);
end


unique_connected_components = unique(out.components);
connected_components_count = length(unique_connected_components);

out.conn_components_count = connected_components_count;
out.c = cell(connected_components_count, 1);
out.options = options;

% find not yet processed components
components_to_process = find(cellfun (@(c) isempty(c), cell(connected_components_count, 1)));
for conn_comp_i = 1:length(components_to_process)
    conn_comp_id = components_to_process(conn_comp_i);
    conn_comp_sel = (out.components == conn_comp_id);
    if options.verbose
       fprintf('Component %d/%d (%d nodes)\n', conn_comp_id, connected_components_count, nnz(conn_comp_sel));
    end
    conn_comp_A = out.A(conn_comp_sel, conn_comp_sel);
    conn_comp_G = G(conn_comp_sel, conn_comp_sel);
    conn_comp_is_ext_node = is_ext_node(conn_comp_sel);
    global_context = find(conn_comp_sel);

    graph_timer = tic;
    after_graph = options.graph_algorithm(conn_comp_G,conn_comp_is_ext_node, conn_comp_A);
    graph_processing_time = toc(graph_timer);
    
    % Eliminate nodes one-by-one
    nodewise_timer = tic;
    d = options.nodewise_algorithm(after_graph.G, after_graph.is_ext_node, options);
    nodewise_processing_time = toc(nodewise_timer); 

    d.new_nodes = global_context(after_graph.new_nodes(d.new_nodes));
    d.graph_processing_time = graph_processing_time;
    d.nodewise_processing_time = nodewise_processing_time;
    out.c{conn_comp_id} = d;
    if (options.auto_save)
      save(options.output_file, 'out');
    end
end
