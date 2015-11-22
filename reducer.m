% Input data
% G: conductance matrix
% Terminals: list of nodes which are terminals
% Output data
% G: reduced equivalent of G

assert(isempty(Terminals(Terminals > length(G))))

% TODO: Connected graph assumed.
% Add steps 1, 2 from Romms and Schilders algorithm

% 3. Compute the two-connected components Gi(2) of Gi
% https://en.wikipedia.org/wiki/Biconnected_component
[articulation_nodes, twoconnected_components] = biconnected_components(G);

% Set diagonal to zero
twoconnected_components(logical(eye(size(twoconnected_components)))) = 0;

% 4. For every two-connected component
components_ids = nonzeros(unique(twoconnected_components));
for comp_id = 1:length(components_ids)
    twoconnected_component = (twoconnected_components == comp_id);
    [row, col] = find(twoconnected_component);

    component_nodes = unique([row col]);
    terminals_in_component = intersect(component_nodes, Terminals);
    a_nodes_in_component = intersect(component_nodes, articulation_nodes);
    terminal_count = length(terminals_in_component);
    a_node_count = length(a_nodes_in_component);

    if terminal_count == 0 && a_node_count == 1
        disp('Remove all resistors and keep articulation node')
        articulation_node = a_nodes_in_component(1);
        g = sum(G(articulation_node, component_nodes));
        G(component_nodes, component_nodes) = 0;
        G(articulation_node, articulation_node) = g;
    elseif a_node_count == 2
        disp('Reduce to single equivalent resistor (two articulation nodes)')
        if length(component_nodes) == 2
            disp('Nothing to reduce')
            continue  % nothing to reduce
        end
        port1 = a_nodes_in_component(1);
        port2 = a_nodes_in_component(2);

        e1 = zeros(length(G), 1);
        e2 = zeros(length(G), 1);
        e1(port1) = 1;
        e2(port2) = 1;
        L = chol(G);
        u = L\(e2-e1);
        R = u'*u;

        gp1 = sum(G(port1, component_nodes));
        gp2 = sum(G(port2, component_nodes));
        G(component_nodes, component_nodes) = 0;
        G(port1, port1) = gp1 + 1/R;
        G(port2, port2) = gp2 + 1/R;
        G(port1, port2) = -1/R;
        G(port2, port1) = -1/R;

    elseif terminal_count == 1 && a_node_count == 1
        disp('Reduce to single equivalent resistor (one term, one articulation node)')
        if length(component_nodes) == 2
            disp('Nothing to reduce')
            continue  % nothing to reduce
        end
        port1 = terminals_in_component(1);
        port2 = a_nodes_in_component(1);

        e1 = zeros(length(G), 1);
        e2 = zeros(length(G), 1);
        e1(port1) = 1;
        e2(port2) = 1;
        L = chol(G);
        u = L\(e2-e1);
        R = u'*u;
        
        gp1 = sum(G(port1, component_nodes));
        gp2 = sum(G(port2, component_nodes));
        G(component_nodes, component_nodes) = 0;
        G(port1, port1) = gp1 + 1/R;
        G(port2, port2) = gp2 + 1/R;
        G(port1, port2) = -1/R;
        G(port2, port1) = -1/R;
    else
        disp('Do nothing')
    end
    
C = ones(1, length(G));
C(Terminals) = 2;
P = camd(G, camd, C);

for n=1:length(P)
    g11 = find(G(:,n) ~= 0);
    G11 = G(g11,g11);
    G12 = G(g11,n);
    G21 = G(n,g11);
    G22 = G(n,n);

    Gr = G11-(G12*inv(G22)*G21);
    n
    Gr
end
end
