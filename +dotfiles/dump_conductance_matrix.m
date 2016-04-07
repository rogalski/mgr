function dump_conductance_matrix( G, handle )
[i,j,v] = find(triu(G, 1));

for k = 1:length(v)
    fprintf(handle,'%i -- %i\n', i(k), j(k));
end
end
