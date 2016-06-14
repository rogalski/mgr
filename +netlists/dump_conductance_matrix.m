function r_count = dump_conductance_matrix( handle, G, node_ids, r_count )

% s = size(G);
sums = sum(G, 2);
[i,j,v] = find(triu(G));

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
        n2 = 0;
    else
        ri = -1/el;
        n2 = node_ids(n);
    end
    if ri < 0 || ri >= 1e10
        continue
    end
    r_count = r_count + 1;
    n1 = node_ids(m);

    fprintf(handle,'R%i %i %i %s\n', r_count, n1, n2, num2str(ri));
end
end
