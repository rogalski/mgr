function [G, is_ext_node] = load_rommes2(name)
d = load(['circuits/rommes2/' name '.mat']);
G = d.G;
is_ext_node = zeros(length(G), 1);
for i=1:size(d.components, 1)
    extnodes = nonzeros(d.component_extnodes(i, :));
    is_ext_node(extnodes) = 1;
end
end
