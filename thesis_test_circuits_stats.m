component_sizes = [];

circuits = {
    {@load_rommes, 'r_network_int46k_ext8k_res67k_public'}, ...
    {@load_rommes, 'r_network_int48k_ext8k_res75k_public'}, ...
    {@load_rommes, 'r_network_int50k_ext4k_res94k_public'}, ...
    {@load_rommes2, 'network_b'}, {@load_rommes2, 'network_c'}, ...
    {@load_mrewiens, 'o1'}
    };

for idx=1:numel(circuits)
    circuit_data_cell_array = circuits(idx);
    circuit_data = circuit_data_cell_array{1};
    loader = circuit_data{1};
    circuit_name = circuit_data{2};
    [G, is_ext_node] = loader(circuit_name);
    [~, sizes] = components(adj(G));
    component_sizes = [component_sizes; sizes]; %#ok<AGROW>
end

max_edge = ceil(log10(max(component_sizes)));
edges = floor(logspace(0, max_edge, max_edge+1));
histogram(component_sizes, edges)
set(gca,'XScale','log');
title('Rozmiar sk³adowych spójnych w obwodach testowych: histogram')
xlabel('Rozmiar sk³adowych')
ylabel('Ilo¶æ sk³adowych')

XTick = get(gca, 'XTick');
XTickLabels = cellstr(num2str(round(log10(XTick(:))), '10^%d'));
set(gca, 'XTickLabel', XTickLabels);
