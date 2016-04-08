num_resistors = nnz(triu(conn_comp_G));
num_terminals = length(conn_comp_ExtNodes);
num_resistors_upper_bound = num_terminals * (num_terminals - 1) / 2;

Gi = conn_comp_G(Perm, Perm);
bestG = Gi;
nodes_to_eliminate = length(conn_comp_G) - length(conn_comp_ExtNodes);
original_cost = nnz(triu(conn_comp_G, 1));
threshold_cost = original_cost;

min_fillin_nodes_eliminated_count = 0;
for nodes_eliminated=1:nodes_to_eliminate
    G11 = Gi(1, 1);
    G12 = Gi(1, 2:end);
    G22 = Gi(2:end, 2:end);
    Gi = G22 + G12' * (-G11\G12);
    cost = nnz(triu(Gi, 1));
    if cost <= threshold_cost
        threshold_cost = cost;
        min_fillin_nodes_eliminated_count = nodes_eliminated;
        bestG = Gi;
    end
end

% TODO: Check upper bound and eliminate all resistors if we know we can
if (threshold_cost > num_resistors_upper_bound)
    min_fillin_nodes_eliminated_count = nodes_to_eliminate;
    Gi = conn_comp_G(Perm, Perm);
    G11 = Gi(1:nodes_to_eliminate, 1:nodes_to_eliminate);
    G12 = Gi(1:nodes_to_eliminate, nodes_to_eliminate+1:end);
    G22 = Gi(nodes_to_eliminate+1:end, nodes_to_eliminate+1:end);
    bestG = G22 + G12' * (-G11\G12);
end

local_nodes_left = Perm(min_fillin_nodes_eliminated_count+1:end);
local_nodes_in_global_circuit = find(conn_comp_sel);
global_nodes_left = local_nodes_in_global_circuit(local_nodes_left);
