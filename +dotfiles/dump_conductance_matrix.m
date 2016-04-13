function dump_conductance_matrix( handle, G, node_ids )


[i,j,v] = find(triu(G, 1));

for k = 1:length(v)
    fprintf(handle,'%i -- %i\n', node_ids(i(k)), node_ids(j(k)));
end
end
