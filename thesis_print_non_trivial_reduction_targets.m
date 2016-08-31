VERBOSE = 0;

circuits = {
    {@load_rommes, 'r_network_int46k_ext8k_res67k_public'}, ...
    {@load_rommes, 'r_network_int48k_ext8k_res75k_public'}, ...
    {@load_rommes, 'r_network_int50k_ext4k_res94k_public'}, ...
    {@load_rommes2, 'network_b'}, {@load_rommes2, 'network_c'}, ...
    {@load_mrewiens, 'o1'}
    };

is_non_trivial = @(i) i.num_nodes >= 20 && i.num_external >= 5 && i.num_internal >= 5;
is_close = @(i1, i2) abs(i1.num_nodes - i2.num_nodes) < 3 && abs(i1.num_internal - i2.num_internal) < 3 && abs(i1.num_external - i2.num_external) < 3;

counter = 0;

for idx=1:numel(circuits)
    circuit_data_cell_array = circuits(idx);
    circuit_data = circuit_data_cell_array{1};
    loader = circuit_data{1};
    circuit_name = circuit_data{2};
    [G, is_ext_node] = loader(circuit_name);
    [c, ~] = components(adj(G));
    
    matched = ones(1, max(c));
    infos = repmat(circuit_info([], []), 1, max(c));
    
    for ci = 1:max(c)
        s = c==ci;
        cGx = G(s, s);
        cis_ext_nodex = is_ext_node(s);

        o = graph_reduce( cGx, cis_ext_nodex, adj(cGx) );
        cG = o.G;
        cis_ext_node = o.is_ext_node;
        
        info = circuit_info(cG, cis_ext_node);
        infos(ci) = info;
        assert(info.num_conn_components <= 1)
        
        if ~is_non_trivial(info)
            matched(ci) = 0;
            continue
        end
        % this is O(n^2), but we do not give a damn, it's only helper
        for co=1:ci-1
            if ~matched(co)
                continue
            end
            if is_close(infos(co), infos(ci))
                matched(ci) = 0;
                break
            end
        end
        if matched(ci)
            counter = counter + 1;
            if VERBOSE
                fprintf(1, '%d. %s component %d\n', counter, circuit_name, ci);
                disp(infos(ci))
            end
        end
    end
    disp(circuit_name)
    disp(mat2str(find(matched)))
end
