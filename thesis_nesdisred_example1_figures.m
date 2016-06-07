close all;

get_filename = @(s) ['nesdisred_example1_' s];

N = 4;
Z1 = zeros(N, N);

% Adjacency matrix
A1 = sign(conv2(eye(N), ones(2),'same')) - eye(N);
A = [A1, Z1, ones(N, 1);
     Z1, A1, ones(N, 1);
     ones(1, 2*N) 0];

% Conductance matrix
G1 = -sign(conv2(eye(N), ones(2),'same')) + eye(N);
G1(1:N+1:end) = -sum(G1) + 1;

G = [G1, Z1, -ones(N, 1);
     Z1, G1, -ones(N, 1);
     -ones(1, 2*N) 2*N];

is_ext_node = [repmat([0, 1, 1, 0], [1, N/2]) 0]';

%input problem 
dotfiles.dump(get_filename('graph_full.dot'), G, is_ext_node);
run_neato(get_filename('graph_full.dot'), '-Gstart=3');

% separation tree
[c, cp, cmember] = nesdis(G, 'sym', [N+1 0 1 0]);
f = figure;
draw_cp_tree(cp, cmember);
xlabel('');
set(f, 'Position', [100, 100, 600, 200])
set(f,'PaperPositionMode','auto')
print(get_filename('tree'), '-deps')
close(f);

% what happens when separator is removed
to_keep = 1:8;
to_remove = 9;

G11 = G(to_keep, to_keep);
G12 = G(to_keep, to_remove);
G22 = G(to_remove, to_remove);
Gnosep = G11-(G12*(G22\(G12')));

dotfiles.dump(get_filename('graph_nosep.dot'), Gnosep, is_ext_node(to_keep));
run_neato(get_filename('graph_nosep.dot'), '-Gstart=1');

% remove both leafs
sel = [1:4 9];
GL = G(sel, sel)
GL(5, 5) = GL(5,5) - 4;

to_keep = [2 3 5];
to_remove = [1, 4];

G11 = GL(to_keep, to_keep);
G12 = GL(to_keep, to_remove);
G22 = GL(to_remove, to_remove);
GLR = G11-(G12*(G22\(G12')))

% separation tree for case 2
[c, cp, cmember] = nesdis(G, 'sym', [N-1 0 1 0]);
f = figure;
draw_cp_tree(cp, cmember);
xlabel('');
set(f,'PaperPositionMode','auto')
set(f, 'Position', [100, 100, 700, 200])
print(get_filename('tree2'), '-deps')
close(f);
