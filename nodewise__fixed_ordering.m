Gi = G(Perm, Perm);
bestG = Gi;
nodes_to_eliminate = length(G) - nnz(is_ext_node);
cost_function = options.cost_function;

original_cost = cost_function(Gi);
threshold_cost = original_cost;

min_fillin_nodes_eliminated_count = 0;

local_fillin_tracker = zeros(1, nodes_to_eliminate);
local_ordering_tracker = Perm(1:nodes_to_eliminate);

early_exit = 0;
for nodes_eliminated=1:nodes_to_eliminate
    if options.verbose && mod(nodes_eliminated, 1000) == 0
        fprintf('Nodewise elimination; %i/%i\n', nodes_eliminated, nodes_to_eliminate)
    end
    G11 = Gi(1, 1);
    G12 = Gi(2:end, 1)';
    G22 = Gi(2:end, 2:end);
    Gi = G22 + G12' * (-G11\G12);
    cost = cost_function(Gi);
    local_fillin_tracker(nodes_eliminated) = cost;
    if cost < threshold_cost
        threshold_cost = cost;
        min_fillin_nodes_eliminated_count = nodes_eliminated;
        bestG = Gi;
    end
    if 0 && length(Gi) > 2000 && (nnz(Gi) / length(Gi) > 20)
        fprintf('Early exit from nodwise')
        early_exit = 1;
        break
    end
end

% TODO: Check upper bound and eliminate all resistors if we know we can
% if (threshold_cost > num_resistors_upper_bound)
%     min_fillin_nodes_eliminated_count = nodes_to_eliminate;
%     Gi = conn_comp_G(Perm, Perm);
%     G11 = Gi(1:nodes_to_eliminate, 1:nodes_to_eliminate);
%     G12 = Gi(1:nodes_to_eliminate, nodes_to_eliminate+1:end);
%     G22 = Gi(nodes_to_eliminate+1:end, nodes_to_eliminate+1:end);
%     bestG = G22 + G12' * (-G11\G12);
% end

local_nodes_left = Perm(min_fillin_nodes_eliminated_count+1:end);
local_nodes_eliminated = Perm(1:min_fillin_nodes_eliminated_count);

reduced_data.G = bestG;
reduced_data.new_nodes = local_nodes_left;
reduced_data.is_ext_node = is_ext_node(local_nodes_left);
reduced_data.eliminated_nodes = local_nodes_eliminated;
reduced_data.early_exit = early_exit;
reduced_data.fillin_tracker = local_fillin_tracker;
