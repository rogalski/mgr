dst_dir = fullfile('test_suites', 'basic');
if exist(dst_dir,'dir')
    rmdir(dst_dir, 's')
end
mkdir(dst_dir)

% mrewiens
create_test_suite_for_circuit(@load_mrewiens, 'o1', ...
                              [], dst_dir);
% rommes
c = [1343 1399 93 90 1400 1403 96 86 1402 92 161 85];
create_test_suite_for_circuit(@load_rommes, 'r_network_int46k_ext8k_res67k_public',...
                              c, dst_dir);
create_test_suite_for_circuit(@load_rommes, 'r_network_int48k_ext8k_res75k_public',...
                              [1:6 9 12], dst_dir);
create_test_suite_for_circuit(@load_rommes, 'r_network_int50k_ext4k_res94k_public',...
                              1:12, dst_dir);
% rommes2
c = [1, 3, 4, 6, 8, 9, 16, 17, 18, 19, 22, 23, 27, 28, 33, 35, 37, 39, 41, 68, 76, 80, 258];
create_test_suite_for_circuit(@load_rommes2, 'network_b',...
                              c, dst_dir);
c = [25, 35, 18, 7, 24, 4, 26, 31, 10, 11, 28, 1, 13];
create_test_suite_for_circuit(@load_rommes2, 'network_c',...
                              c, dst_dir);
disp all_done
