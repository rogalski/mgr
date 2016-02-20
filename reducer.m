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
twoconnected_components(logical(speye(size(twoconnected_components)))) = 0;

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
        % Dangling network: remove all resistors and keep articulation node'
        articulation_node = a_nodes_in_component(1);
        g = sum(G(articulation_node, component_nodes));
        G(component_nodes, component_nodes) = 0;
        G(articulation_node, articulation_node) = g;
    elseif length(component_nodes) == 2
        continue
    elseif a_node_count == 2 || (terminal_count == 1 && a_node_count == 1)
        % Reduce to single equivalent resistor
        port1 = a_nodes_in_component(1);
        if isempty(terminals_in_component)
            port2 = a_nodes_in_component(2);
        else
            port2 = terminals_in_component(1);
        end
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
        % Triconnected components 
        biconn_comp_copy = twoconnected_component;
        biconn_comp_copy(~any(biconn_comp_copy,2), :) = [];
        biconn_comp_copy(:, ~any(biconn_comp_copy,1)) = [];
        [edges, types] = TricComp(biconn_comp_copy);
        types
        clear twoconnected_component_copy
    end
end
return

% TODO: node reductions will be next step
NewTerminalsMask = zeros(1,length(G));
NewTerminalsMask(Terminals) = 1;
nodes_to_remove = find(all(G==0,2));
G(nodes_to_remove, :) = [];
G(:, nodes_to_remove) = [];
NewTerminalsMask(nodes_to_remove) = [];
NewTerminals = find(NewTerminalsMask);

constrains = ones(1, length(G));
constrains(NewTerminals) = 2;
P = camd(G, camd, constrains);

for n=1:length(P)
    g11 = find(G(:,n) ~= 0);
    G11 = G(g11,g11);
    G12 = G(g11,n);
    G21 = G(n,g11);
    G22 = G(n,n);
    Grepl = G11-(G12*inv(G22)*G21);
end

nodes_to_remove = find(all(G==0,2));
G(nodes_to_remove, :) = [];
G(:, nodes_to_remove) = [];
