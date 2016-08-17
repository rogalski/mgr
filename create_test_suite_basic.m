dst_dir = fullfile('test_suites', 'basic');

PURGE = 1;
if PURGE && exist(dst_dir,'dir')
    rmdir(dst_dir, 's')
end
mkdir(dst_dir)

% mrewiens
% c = [1:6];
c = [];
create_test_suite_for_circuit(@load_mrewiens, 'o1', ...
    c, dst_dir);
% rommes
c = [1 2 85 86 87 88 90 92 93 96 161 325 761 1264 1265 1298 1299 1300 1302 1315 1316 1343 1344 1369 1370 1394 1399 1400 1402 1403 1404 1406];
create_test_suite_for_circuit(@load_rommes, 'r_network_int46k_ext8k_res67k_public',...
    c, dst_dir);
c = [1 2 3 5 6];
create_test_suite_for_circuit(@load_rommes, 'r_network_int48k_ext8k_res75k_public',...
    c, dst_dir);
c = [1 2 3 4 5 7 8 9 10 11 12 43];
create_test_suite_for_circuit(@load_rommes, 'r_network_int50k_ext4k_res94k_public',...
    c, dst_dir);
% rommes2
c = [1 2 3 4 5 6 8 9 10 16 17 18 19 22 23 27 28 33 34 35 37 39 41 63 65 68 76 80 126 258];
create_test_suite_for_circuit(@load_rommes2, 'network_b',...
    c, dst_dir);
c = [1 2 4 5 7 8 10 11 12 13 14 15 18 19 22 23 24 25 26 28 29 31 33 35 36 37 38 42 47 51 52 60 66 69 82 85];
create_test_suite_for_circuit(@load_rommes2, 'network_c',...
    c, dst_dir);
disp all_done
