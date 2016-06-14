%#ok<*ASGLU>
dst_dir = fullfile('test_suites', 'big');
if exist(dst_dir,'dir')
    rmdir(dst_dir, 's')
end
mkdir(dst_dir)

% mrewiens
% create_test_suite_for_circuit(@load_mrewiens, 'o1', ...
%                               [], dst_dir);
% rommes
name = 'r_network_int46k_ext8k_res67k_public';
[G, is_ext_node] = load_rommes(name);
save(fullfile(dst_dir, name), 'G', 'is_ext_node');

name = 'r_network_int48k_ext8k_res75k_public';
[G, is_ext_node] = load_rommes(name);
save(fullfile(dst_dir, name), 'G', 'is_ext_node');

name = 'r_network_int50k_ext4k_res94k_public';
[G, is_ext_node] = load_rommes(name);
save(fullfile(dst_dir, name), 'G', 'is_ext_node');

name = 'network_b';
[G, is_ext_node] = load_rommes2(name);
save(fullfile(dst_dir, name), 'G', 'is_ext_node');

name = 'network_c';
[G, is_ext_node] = load_rommes2(name);
save(fullfile(dst_dir, name), 'G', 'is_ext_node');

disp all_done
