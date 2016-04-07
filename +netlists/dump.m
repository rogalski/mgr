function dump(filename, G, ExtNodes)
handle = fopen(filename, 'W');
fprintf(handle,'%% Netlist dump from %s\n', datestr(datetime));
netlists.dump_conductance_matrix(G, handle);
fprintf(handle,'V1 %d 0 0\n', ExtNodes(1));
fprintf(handle,'V2 %d 0 1\n', ExtNodes(2));
fprintf(handle,'.OP\n');
fclose(handle);
end
