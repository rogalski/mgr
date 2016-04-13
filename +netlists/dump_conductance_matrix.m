function r_count = dump_conductance_matrix( handle, G, node_ids, r_count )

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
    fprintf(handle,'R%i %i %i %s\n', r_count, node_ids(m), node_ids(n), num2str(ri));
end
end
