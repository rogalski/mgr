groups = {'camd-count_resistors-', 'recursive_amd-count_resistors-', ...
    'nesdis_camd-count_resistors-100', 'nesdis_dummy--5'};
testcases = dir(fullfile('results', groups{1}, '*.mat'));
tc_count = length(testcases);
group_count = length(groups);
time_solve = zeros(1+group_count, tc_count);

tc_num = 0;
for tc_file=testcases'
    tc_num = tc_num+1;
    group_num = 0;
    for g=groups
        group_num = group_num+1;
        load(fullfile('results', g{1}, tc_file.name));
        
        % add some grounded resistors on ports to emulate real circuit
        g_t = 1e-5;
        
        G = G + sparse(1:length(G), ...
            1:length(G), ...
            is_ext_node * g_t);
        output.c{1}.G = output.c{1}.G + sparse(1:length(output.c{1}.G), ...
            1:length(output.c{1}.G), ...
            output.c{1}.is_ext_node' * g_t);
        
        r1 = rand(size(is_ext_node)) .* is_ext_node;
        r2 = rand(size(output.c{1}.is_ext_node)) .* output.c{1}.is_ext_node;
    
        t1 = timeit(@() cholmod2(G, r1));
        t2 = timeit(@() cholmod2(output.c{1}.G, r2));
 
        if group_num==1
            time_solve(1, tc_num) = t1;
        end
        time_solve(group_num+1, tc_num) = t2;
    end
end
   
etime_solve = time_solve';
times_scaled = bsxfun(@rdivide,time_solve,max(time_solve,[],2));
figure;
bar(times_scaled);
legend('bez redukcji', 'CAMD', 'recursive AMD', 'nesdisred(camd, 50)', 'resdisred(5)');
ylabel('Wzglêdny czas rozwi±zania - lower is better')

performance = 1 ./ times_scaled;
figure;
bar(performance);
legend('bez redukcji', 'CAMD', 'recursive AMD', 'nesdisred(camd, 50)', 'resdisred(5)');
ylabel('¦rednia wydajno¶æ - higher is better')
