% Input data
% G: Conductance matrix
% A: Adjacency matrix
% ExtNodes: numbers of external nodes
% IsExtNode: vector of flags if node is external

% Output data
% G: reduced equivalent of G
assert(all(size(G) == size(A)));
assert(length(IsExtNode) == size(G, 1));

% 1. Compute connected components Gi of G
connected_components = components(A);

unique_connected_components = unique(connected_components);

for conn_comp_i = 1:length(unique_connected_components)
    conn_comp_id = unique_connected_components(conn_comp_i);
    conn_comp_sel = (connected_components == conn_comp_id);
    
    conn_comp_A = A(conn_comp_sel, conn_comp_sel);
    conn_comp_G = G(conn_comp_sel, conn_comp_sel);
    conn_comp_ExtNodes = find(IsExtNode(conn_comp_sel));
    
    % 2. For every connected component Gi in G with one or more terminals
    if length(conn_comp_ExtNodes) < 1
        continue  % Nets may be removed entirely
    end
    % 3. Compute the two-connected components Gi(2) of Gi
    [articulation_nodes, biconn_components] = biconnected_components(conn_comp_A);
    biconn_comp_ids = nonzeros(unique(biconn_components));
    % 4. For every two-connected component Gi(2) of Gi
    for biconn_comp_i = 1:length(biconn_comp_ids)
        biconn_comp_id = biconn_comp_ids(biconn_comp_i);
        [found_in_rows, ~] = find(biconn_components == biconn_comp_id);
        biconn_comp_nodes = unique(found_in_rows);
        ExtNodes_in_component = intersect(biconn_comp_nodes, conn_comp_ExtNodes);
        a_nodes_in_component = intersect(biconn_comp_nodes, articulation_nodes);
        non_removable_nodes_in_component = [ExtNodes_in_component; a_nodes_in_component];
        terminal_count = length(ExtNodes_in_component);
        a_node_count = length(a_nodes_in_component);
        clear found_in_rows
        if terminal_count == 0 && a_node_count == 1
            % 5. - 6. Dangling node
            articulation_node = a_nodes_in_component(1);
            % A(component_nodes, component_nodes) = 0;
            g = sum(conn_comp_G(articulation_node, biconn_comp_nodes));
            conn_comp_G(biconn_comp_nodes, biconn_comp_nodes) = 0;
            conn_comp_G(articulation_node, articulation_node) = g;
        elseif length(biconn_comp_nodes) == 2
            continue
        elseif (a_node_count == 2 && terminal_count == 0) || (a_node_count == 1 && terminal_count == 1)
            % 7. - 10. Reduce to single equivalent resistor
            port1 = a_nodes_in_component(1);
            if a_node_count == 2
                port2 = a_nodes_in_component(2);
            else
                port2 = ExtNodes_in_component(1);
            end
            % A(component_nodes, component_nodes) = 0;
            % A(port1, port2) = 1;
            % A(port2, port1) = 1;
            to_remove = biconn_comp_nodes(biconn_comp_nodes ~= port1 & biconn_comp_nodes ~= port2);
            to_keep = [port1 port2];
            
            G11 = conn_comp_G(to_keep, to_keep);
            G12 = conn_comp_G(to_keep, to_remove);
            G22 = conn_comp_G(to_remove, to_remove);
            Gp = G11-(G12*(G22\(G12')));
            conn_comp_G(biconn_comp_nodes, biconn_comp_nodes) = 0;
            conn_comp_G(to_keep, to_keep) = Gp;
            clear G11 G12 G22 Gp to_remove to_keep
        else
            continue
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
        constrains = ones(1, length(conn_comp_G));
        constrains(conn_comp_ExtNodes) = 2;
        P2 = camd(conn_comp_G, camd, constrains);
        
        total_nodes_to_analyze = length(nonzeros(constrains == 1));
        for k=1:total_nodes_to_analyze
            n = P2(k);
            g11 = find(conn_comp_G(:, n));
            if isempty(g11)
                continue
            end
            % CSR sparse matrix - selecting columns first, then rows is quicker
            G11_columns = conn_comp_G(:,g11);
            G11 = G11_columns(g11,:);
            
            % Same as above
            G12_columns = conn_comp_G(:,n);
            G12 = G12_columns(g11,:);
            
            G22 = conn_comp_G(n,n);
            
            Gp = G11-(G12*(G22\G12'));
            
            if nnz(G11) >= nnz(Gp)
                % CSR sparse matrix...
                G11_columns(g11, :) = Gp;
                conn_comp_G(:,g11) = G11_columns;
            end
            clear g11 G11 G12 G22 Gp G11_columns G12_columns
        end
    end
    G(conn_comp_sel, conn_comp_sel) = conn_comp_G;
end
