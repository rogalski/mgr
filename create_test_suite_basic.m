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
c = [85 86 87 88 90 92 93 96 161 325 1265 1298 1299 1300 1301 1302 1315 1317 1343 1344 1399 1400 1402 1403];
create_test_suite_for_circuit(@load_rommes, 'r_network_int46k_ext8k_res67k_public',...
    c, dst_dir);
c = [1 2 3 4 5 6 12];
create_test_suite_for_circuit(@load_rommes, 'r_network_int48k_ext8k_res75k_public',...
    c, dst_dir);
c = 1:12;
create_test_suite_for_circuit(@load_rommes, 'r_network_int50k_ext4k_res94k_public',...
    c, dst_dir);
% rommes2
c = [1 2 3 4 5 6 8 9 10 11 12 15 16 17 18 19 20 21 22 23 24 27 28 29 31 33 35 37 39 40 41 42 43 44 45 46 48 52 53 54 58 62 63 65 68 69 70 72 75 76 78 80 81 83 84 85 86 87 89 91 93 95 97 98 100 101 103 106 107 109 114 118 120 121 122 123 124 127 128 131 137 138 139 141 147 152 155 158 163 171 173 174 175 177 182 196 200 212 214 216 222 224 225 233 242 248 255 258 265 290];
create_test_suite_for_circuit(@load_rommes2, 'network_b',...
    c, dst_dir);
c = [1 2 4 5 7 9 10 11 12 13 14 15 16 17 18 19 20 23 24 25 26 27 28 29 30 31 32 33 35 36 37 38 40 41 42 43 44 45 49 52 54 55 56 59 60 64 65 66 67 68 70 72 74 79 85 86 87];
create_test_suite_for_circuit(@load_rommes2, 'network_c',...
    c, dst_dir);
disp all_done
