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
c = [85 86 87 88 90 92 93 96 161 325 1265 1298 1300 1301 1302 1343 1344 1399 1400 1402 1403];
create_test_suite_for_circuit(@load_rommes, 'r_network_int46k_ext8k_res67k_public',...
    c, dst_dir);
c = [1 2 3 5 6];
create_test_suite_for_circuit(@load_rommes, 'r_network_int48k_ext8k_res75k_public',...
    c, dst_dir);
c = [1 2 3 4 5 6 7 8 9 10 11 12];
create_test_suite_for_circuit(@load_rommes, 'r_network_int50k_ext4k_res94k_public',...
    c, dst_dir);
% rommes2
c = [1 2 3 4 5 6 8 9 11 12 15 16 17 18 19 20 22 23 24 27 28 29 33 35 37 39 40 41 42 44 45 46 48 53 58 62 63 65 68 69 70 75 76 80 81 84 85 86 87 91 95 101 103 107 123 124 128 137 138 141 147 171 174 175 177 182 200 212 216 222 224 225 242 258];
create_test_suite_for_circuit(@load_rommes2, 'network_b',...
    c, dst_dir);
c = [1 4 5 7 9 10 11 12 13 14 15 16 17 18 19 20 23 24 25 26 27 28 29 30 31 32 33 35 36 37 38 40 41 42 43 45 49 52 54 55 56 59 60 65 66 67 68 70 72 74 85 86 87];
create_test_suite_for_circuit(@load_rommes2, 'network_c',...
    c, dst_dir);
disp all_done
