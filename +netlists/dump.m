function dump(filename, G)
handle = fopen(filename, 'w');
fprintf(handle,'%% Netlist dump from %s\n', datestr(datetime));
netlists.dump_conductance_matrix(G, handle);
fclose(handle);

end
