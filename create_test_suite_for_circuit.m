function [ output_args ] = create_test_suite_for_circuit( loader, circuit_name, selected_components, dst_dir )
parts = strsplit(func2str(loader), '_');
group_name = parts{2};

[Gx, is_ext_nodex] = loader(circuit_name);
c = components(adj(Gx));
result_filename = @(c) [group_name '_' circuit_name '_' num2str(c, '%.4d') '.mat'];

disp(group_name)
disp(circuit_name)
disp(selected_components)

for ci=selected_components
    dst = result_filename(ci);
    G = Gx(c==ci, c==ci);
    is_ext_node = is_ext_nodex(c==ci);
    save(fullfile(dst_dir, dst), 'G', 'is_ext_node');
    disp .
end
end
