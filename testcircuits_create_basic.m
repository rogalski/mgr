VERBOSE = 0;
PURGE = 0;
RESULTS_DIR = fullfile('test_suites', 'basic');
rmdir(RESULTS_DIR, 's');
mkdir(RESULTS_DIR);


circuits = {
    {@load_rommes, 'r_network_int46k_ext8k_res67k_public'}, ...
    {@load_rommes, 'r_network_int48k_ext8k_res75k_public'}, ...
    {@load_rommes, 'r_network_int50k_ext4k_res94k_public'}, ...
    {@load_rommes2, 'network_b'}, {@load_rommes2, 'network_c'}, ...
    % {@load_mrewiens, 'o1'}
    };

is_non_trivial = @(i) i.num_nodes >= 10 && i.num_external >= 4;
is_close = @(i1, i2) abs(i1.num_nodes - i2.num_nodes) < 10 && abs(i1.num_internal - i2.num_internal) < 10 && abs(i1.num_external - i2.num_external) < 10;

counter = 0;

cinfo_tpl = circuit_info([], []);
cinfo_tpl.cnum = 0;
cinfo_tpl.ccidx = 0;
cinfo_tpl.fname = '';

all_infos = repmat(cinfo_tpl, 1, 0);

for circuit_number=1:numel(circuits)
    circuit_data_cell_array = circuits(circuit_number);
    circuit_data = circuit_data_cell_array{1};
    loader = circuit_data{1};
    circuit_name = circuit_data{2};
    [G, is_ext_node] = loader(circuit_name);
    [c, ~] = components(adj(G));
    
    circuit_matched = ones(1, max(c));
    circuit_infos = repmat(cinfo_tpl, 1, max(c));
    
    for connected_component_number = 1:max(c)
        s = c==connected_component_number;
        cGx = G(s, s);
        cis_ext_nodex = is_ext_node(s);
        
        o = graph_reduce( cGx, cis_ext_nodex, adj(cGx) );
        cG = o.G;
        cis_ext_node = o.is_ext_node;
        
        info = circuit_info(cG, cis_ext_node);
        info.cnum = circuit_number;
        info.ccidx = connected_component_number;
        info.fname = '';
        circuit_infos(connected_component_number) = info;
        assert(info.num_conn_components <= 1)
        
        if ~is_non_trivial(info)
            circuit_matched(connected_component_number) = 0;
            continue
        end
        % this is O(n^2), but we do not give a damn, it's only helper
        for co=1:connected_component_number-1
            if ~circuit_matched(co)
                continue
            end
            if is_close(circuit_infos(co), circuit_infos(connected_component_number))
                circuit_matched(connected_component_number) = 0;
                break
            end
        end
        if circuit_matched(connected_component_number)
            fname =  [tempname(RESULTS_DIR),'.mat'];
            circuit_infos(connected_component_number).fname = fname;
            ToSave.G = cG;
            ToSave.is_ext_node = cis_ext_node;
            save(fname, '-struct', 'ToSave')
        end
    end
    all_infos = [all_infos circuit_infos(circuit_matched==1)];
    disp(circuit_name)
    disp(mat2str(find(circuit_matched)))
end

all_infos = sortStruct(all_infos, 'num_nodes');
for idx=1:length(all_infos)
    movefile(all_infos(idx).fname, fullfile(RESULTS_DIR, [num2str(idx, '%.3d') '.mat']))
end

indicies = [1:length(all_infos)]';
circuit_num = [all_infos(:).cnum]';
ccid = [all_infos(:).ccidx]';
num_nodes_t = [all_infos(:).num_nodes]';
num_nodes_i = [all_infos(:).num_internal]';
num_nodes_e = [all_infos(:).num_external]';
num_res = [all_infos(:).num_resistors]';
t = table(indicies, num_nodes_t, num_nodes_i, num_nodes_e, num_res, circuit_num, ccid)
writetable(t, 'tc_basic.csv');
