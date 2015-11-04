function dump_conductance_matrix( G, handle )
r_count = uint8(0);
lower = tril(G);
for k = 1:numel(lower)
    el = lower(k);
    if el == 0
        continue
    end
    [m, n] = ind2sub(size(G), k);
    if m == n
        ri = 1/sum(G(m, :));
        n = 0;  % GND
    else
        ri = -1/el;
    end
    r_count = r_count + 1;
    fprintf(handle,'R%i %i %i %f\n', r_count, m, n, ri);
end
end
