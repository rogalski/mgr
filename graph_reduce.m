function [ out ] = graph_reduce( G, is_ext_node, A )
if (~exist('A', 'var'))
    A = adj(G);
end

out = struct;
out.G = [];
out.removed_nodes = [];
out.new_nodes = [];
out.is_ext_new_node = [];

removed_nodes = zeros(1, length(G));

% 2. For every connected component Gi in G with one or more terminals
if ~any(is_ext_node)
    out.removed_nodes = 1:length(G);
    return
end

% 3. Compute the two-connected components Gi(2) of Gi
[articulation_nodes, biconn_components] = biconnected_components(A);

% 4. For every two-connected component Gi(2) of Gi
for biconn_comp_id = 1:max(biconn_components)
    [found_in_rows, ~] = find(biconn_components == biconn_comp_id);
    biconn_comp_nodes = unique(found_in_rows);
    ext_nodes_in_comp = intersect(biconn_comp_nodes, find(is_ext_node));
    a_nodes_in_component = intersect(biconn_comp_nodes, articulation_nodes);
    terminal_count = length(ext_nodes_in_comp);
    a_node_count = length(a_nodes_in_component);
    if terminal_count == 0 && a_node_count == 1
        % 5. - 6. Dangling node
        articulation_node = a_nodes_in_component(1);
        % A(component_nodes, component_nodes) = 0;
        g = sum(G(articulation_node, biconn_comp_nodes));
        G(biconn_comp_nodes, biconn_comp_nodes) = 0;
        G(articulation_node, articulation_node) = g;

        removed_nodes(biconn_comp_nodes) = 1;
        removed_nodes(articulation_node) = 0;

    elseif length(biconn_comp_nodes) == 2
        continue
    elseif (a_node_count == 2 && terminal_count == 0) || (a_node_count == 1 && terminal_count == 1)
        % 7. - 10. Reduce to single equivalent resistor
        port1 = a_nodes_in_component(1);
        if a_node_count == 2
            port2 = a_nodes_in_component(2);
        else
            port2 = ext_nodes_in_comp(1);
        end
        % A(component_nodes, component_nodes) = 0;
        % A(port1, port2) = 1;
        % A(port2, port1) = 1;
        to_remove = biconn_comp_nodes(biconn_comp_nodes ~= port1 & biconn_comp_nodes ~= port2);
        to_keep = [port1 port2];
        G11 = G(to_keep, to_keep);
        G12 = G(to_keep, to_remove);
        G22 = G(to_remove, to_remove);
        Gi = G11-(G12*(G22\(G12')));
        G(biconn_comp_nodes, biconn_comp_nodes) = 0;
        G(to_keep, to_keep) = Gi;

        removed_nodes(to_remove) = 1;
    else
        %{
        twoconnected_component = conn_comp_G(component_nodes, component_nodes);
        twoconnected_component(logical(speye(size(twoconnected_component)))) = 0;
        [edges, types, virt_edges] = TricComp(twoconnected_component);
        triconnected_components = twoconnected_component;
        triconnected_components(component_nodes, component_nodes) = edges;
        for t=1:length(types)
            if types(t) ~= 1
                continue
            end
            tric_comp = triconnected_components == t;
            [found_in_rows_tric, ~] = find(tric_comp);
            tric_comp_nodes = unique(found_in_rows_tric);
            if length(tric_comp_nodes) <= 2
                continue
            end
            if virt_edges(1, t) == 0 || virt_edges(2, t) == 0
                continue
            end
            port1 = component_nodes(virt_edges(1, t));
            port2 = component_nodes(virt_edges(2, t));
            ExtNodes_in_tric_comp = intersect(tric_comp_nodes, ExtNodes);

            to_keep = unique([port1; port2; ExtNodes_in_tric_comp]);
            to_remove = setdiff(tric_comp_nodes, to_keep);
            if isempty(to_remove)
                continue
            end

            G11 = G(to_keep, to_keep);
            G12 = G(to_keep, to_remove);
            G22 = G(to_remove, to_remove);
            Gn = G11-(G12*(G22\(G12')));
            G(to_keep, to_keep) = Gn;
            clear G11 G12 G22 Gn
        end
        %}
    end
end

out.G = G(~removed_nodes, ~removed_nodes);
out.removed_nodes = find(removed_nodes);
out.new_nodes = find(~removed_nodes);
out.is_ext_new_node = is_ext_node(out.new_nodes);
end
