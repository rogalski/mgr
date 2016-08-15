function is_correct = check_reduction_correctness( G, is_ext_node, Gred, new_nodes )
% Checks for reduction correctness when reduced circuit has single
% connected component.
old_ext_nodes = find(is_ext_node);
if length(old_ext_nodes) > 100
    warning('Check randomly selected subset of terminals ONLY.')
    terminals_selection = randsample(old_ext_nodes, 100);
    terminal_pairs_to_check = nchoosek(terminals_selection, 2);
else
    terminal_pairs_to_check = nchoosek(old_ext_nodes, 2);
end

disp prepare1
% Prepare old circuit for pathres computations
P = amd(G);
L = chol(G(P, P), 'lower');

disp prepare2
% Prepare new circuit for pathres computations
% new_nodes = new_nodes;
Gr = Gred;
Pr = amd(Gr);
Lr = chol(Gr(Pr, Pr), 'lower');

disp check
is_correct = 1;
for k=1:size(terminal_pairs_to_check, 1)
    t1 = terminal_pairs_to_check(k, 1);
    t2 = terminal_pairs_to_check(k, 2);
    
    Rref = fast_path_resistance(L, P==t1, P==t2);
    Rred = fast_path_resistance(Lr, Pr==find(new_nodes==t1), Pr==find(new_nodes==t2));
    
    difference = 100*(1-Rred/Rref);
    if (abs(difference) > 1e-7)
        fprintf('T1: %4d; T2: %4d; Rref: %2.5f; Rred: %2.5f, diff: %4f%%\n', t1, t2, Rref, Rred, difference)
        is_correct = 0;
    end
end
