Gi = conn_comp_G(Perm, Perm);
bestG = Gi;
nodes_to_eliminate = length(conn_comp_G) - length(conn_comp_ExtNodes);
original_cost = nnz(triu(conn_comp_G, 1));
threshold_cost = original_cost;

min_fillin_nodes_eliminated = 0;
for nodes_eliminated=1:nodes_to_eliminate
    G11 = Gi(1, 1);
    G12 = Gi(1, 2:end);
    G22 = Gi(2:end, 2:end);
    % Gp = G11-(G12*(G22\G12'));
    Gi = G22 + G12' * (-G11\G12);
    cost = nnz(triu(Gi, 1));
    if cost <= threshold_cost
        threshold_cost = cost;
        min_fillin_nodes_eliminated = nodes_eliminated;
        bestG = Gi;
    end
end

local_nodes_left = Perm(min_fillin_nodes_eliminated+1:end);
local_nodes_in_global_circuit = find(conn_comp_sel);
global_nodes_left = local_nodes_in_global_circuit(local_nodes_left);
