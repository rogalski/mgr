function v_count = dump_voltage_sources( handle, is_ext_node, node_ids, v_count )

ext_nodes = find(is_ext_node);
for k=1:length(ext_nodes)
    n = node_ids(ext_nodes(k));
    v_count = v_count + 1;
    fprintf(handle,'V%i %i 0 %f\n', v_count, n, rand(1));
end
end
