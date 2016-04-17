perm = reorder_function(G);
Gi = G(perm, perm);
bestG = Gi;
original_cost = nnz(triu(G, 1));
threshold_cost = original_cost;

nodes_to_eliminate = length(G) - nnz(is_ext_node);
local_fillin_tracker = zeros(1, nodes_to_eliminate);

ext_nodes_moved = 0;
early_exit = 0;
min_fillin_nodes_eliminated_count = 0;
for n=1:nodes_to_eliminate
    while is_ext_node(perm(n))
        to_change_range = n:(length(perm)-ext_nodes_moved);
        perm_to_change = perm(to_change_range);
        sel_G_to_reorder = 2:(length(Gi)-ext_nodes_moved);
        G_to_reorder = Gi(sel_G_to_reorder, sel_G_to_reorder);
        local_perm = [(reorder_function(G_to_reorder)+1) 1];
        perm(to_change_range) = perm_to_change(local_perm);
        if ext_nodes_moved > 0
            Gi = Gi([local_perm (end-ext_nodes_moved+1):end], [local_perm (end-ext_nodes_moved+1):end]);
        else
            Gi = Gi(local_perm, local_perm);
        end
        ext_nodes_moved = ext_nodes_moved + 1;
    end                         
    G11 = Gi(1, 1);
    G12 = Gi(1, 2:end);
    G22 = Gi(2:end, 2:end);
    Gi = G22 + G12' * (-G11\G12);
    cost = nnz(triu(Gi, 1));
    local_fillin_tracker(n) = cost;
    if cost < threshold_cost
        threshold_cost = cost;
        min_fillin_nodes_eliminated_count = n;
        bestG = Gi;
    end
    if cost > 2*original_cost
        early_exit = 1;
        break
    end    
end


local_nodes_left = perm(min_fillin_nodes_eliminated_count+1:end);
local_nodes_eliminated = perm(1:min_fillin_nodes_eliminated_count);

