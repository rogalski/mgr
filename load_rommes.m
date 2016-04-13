function [G, is_ext_node] = load_rommes(name)
    d = load(['circuits/rommes/' name '.mat'], 'G', 'isextnode');
    G = d.G;
    is_ext_node = d.is_ext_node;
end
