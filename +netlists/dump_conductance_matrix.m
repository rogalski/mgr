function dump_conductance_matrix( G, handle )
r_count = uint32(0);
% s = size(G);
sums = sum(G, 2);
[i,j,v] = find(tril(G));

for k = 1:length(v)
    m = i(k);
    n = j(k);
    el = v(k);
    if isnan(el)
       continue 
    end
    if m == n
        ri = 1/sums(m);
        n = 0;  % GND
    else
        ri = -1/el;
    end
    if abs(ri) >= 1e12
        continue
    end
    r_count = r_count + 1;
    fprintf(handle,'R%i %i %i %s\n', r_count, m, n, num2str(ri));
end
end
