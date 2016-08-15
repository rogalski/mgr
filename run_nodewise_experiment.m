function [datapoints, cost_values, ngspice_times] = run_nodewise_experiment( G, is_ext_node, step, cost_func_handles, ngspice_func_handles, tmp_dir, do_camd )
if do_camd
    perm = camd(G, camd, is_ext_node+1);
else
    perm = [find(~is_ext_node); find(is_ext_node)];
end
G = G(perm, perm);
is_ext_node = is_ext_node(perm);

input_size = length(G);
to_remove_size = nnz(is_ext_node==0);
datapoints = step:step:to_remove_size;
datapoints_length = length(datapoints);
cost_values = nan(length(cost_func_handles), datapoints_length);
ngspice_times = nan(length(ngspice_func_handles), datapoints_length);

mkdir(tmp_dir);

for k=1:to_remove_size
    G11 = G(1, 1);
    G12 = G(2:end, 1)';
    G22 = G(2:end, 2:end);
    G = G22 + G12' * (-G11\G12);
    if mod(k, step) == 0
        datapoint = k / step;
        cirfile = fullfile(tmp_dir, [num2str(k) '.cir']);
        netlists.dump(cirfile, G, is_ext_node(k+1:end), k+1:input_size)
        
        log_file = ngspice.run(cirfile);
        for fun_index=1:length(ngspice_func_handles)
            ngspice_fun=ngspice_func_handles{fun_index};
            ngspice_times(fun_index, datapoint) = ngspice_fun(log_file);
        end
        
        for fun_index=1:length(cost_func_handles)
            cost_fun=cost_func_handles{fun_index};
            cost_values(fun_index, datapoint) = cost_fun(G);
        end
    end
end
end
