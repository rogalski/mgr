function run_multiple(tcs)
for k=1:length(tcs)
    testcases.run_one(tcs(k))
end
end
