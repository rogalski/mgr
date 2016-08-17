function create_test_suite_for_circuit( loader, circuit_name, selected_components, dst_dir )
parts = strsplit(func2str(loader), '_');
group_name = parts{2};

[Gx, is_ext_nodex] = loader(circuit_name);
circuit_components = components(adj(Gx));
result_filename = @(t, i, e, c) ['T' num2str(t), '-I' num2str(i) '-E' num2str(e) '_' group_name '_' circuit_name '_' num2str(c, '%.4d') '.mat'];

disp(group_name)
disp(circuit_name)
disp(selected_components)

for ci=selected_components
    G = Gx(circuit_components==ci, circuit_components==ci);
    is_ext_node = is_ext_nodex(circuit_components==ci);
    info = circuit_info(G, is_ext_node);
    dst = result_filename(info.num_nodes, info.num_internal, info.num_external, ci);
    save(fullfile(dst_dir, dst), 'G', 'is_ext_node');
    disp .
end
end
