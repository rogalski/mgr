function dump_conductance_matrix( G, handle )
r_count = uint32(0);
lower = tril(G);
s = size(G);
sums = sum(G, 2);
nz = find(lower);

for k = 1:length(nz)
    nz_k = nz(k);
    el = lower(nz_k);
    [m, n] = ind2sub(s, nz_k);
    if m == n
        ri = 1/sums(m);
        n = 0;  % GND
    else
        ri = -1/el;
    end
    if abs(ri) >= 2e12
        continue
    end
    r_count = r_count + 1;
    fprintf(handle,'R%i %i %i %s\n', r_count, m, n, num2str(ri));
end
end
