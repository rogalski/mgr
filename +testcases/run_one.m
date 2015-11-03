function run_one(tc)
disp 'Run test:'
disp(tc)
run(char(tc))
run('fastr.m')
e = 1e-6;
assert(sum(abs(v - V) >= e) == 0)
end
