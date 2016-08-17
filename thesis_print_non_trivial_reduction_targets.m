VERBOSE = 0;

circuits = {
    {@load_rommes, 'r_network_int46k_ext8k_res67k_public'}, ...
    {@load_rommes, 'r_network_int48k_ext8k_res75k_public'}, ...
    {@load_rommes, 'r_network_int50k_ext4k_res94k_public'}, ...
    {@load_rommes2, 'network_b'}, {@load_rommes2, 'network_c'}, ...
    {@load_mrewiens, 'o1'}
    };

is_non_trivial = @(i) i.num_nodes >= 100 && i.num_external >= 5 && i.num_internal >= 10;

counter = 0;

for idx=1:numel(circuits)
    circuit_data_cell_array = circuits(idx);
    circuit_data = circuit_data_cell_array{1};
    loader = circuit_data{1};
    circuit_name = circuit_data{2};
    [G, is_ext_node] = loader(circuit_name);
    [c, ~] = components(adj(G));
    
    local_found = [];
    
    for ci = 1:max(c)
        s = c==ci;
        cG = G(s, s);
        cis_ext_node = is_ext_node(s);
        
        info = circuit_info(cG, cis_ext_node);
        assert(info.num_conn_components == 1)
        
        if is_non_trivial(info)
            counter = counter + 1;
            local_found = [local_found ci]; %#ok<AGROW>
            if VERBOSE
                fprintf(1, '%d. %s component %d\n', counter, circuit_name, ci);
            end
        end
    end
    disp(circuit_name)
    disp(mat2str(local_found))
end
