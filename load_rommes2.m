load(['circuits/rommes2/' CIRCUIT_NAME '.mat'])
A = adj(G);
IsExtNode = zeros(length(G), 1);

for i=1:size(components, 1)
    extnodes = nonzeros(component_extnodes(i, :));
    IsExtNode(extnodes) = 1;
end
ExtNodes = find(IsExtNode);

clear components nr_nodes_component component_extnodes
clear nr_extnodes_component nr_intnodes_component nr_resistors_component
