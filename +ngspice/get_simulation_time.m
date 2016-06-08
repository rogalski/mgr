function t = get_simulation_time( log_file )
%GET_SIMULATION_TIME Retrieves sim time from ngspice log file.
prefix = 'Total analysis time = ';
prefix_length = length(prefix);

handle = fopen(log_file);

l = fgetl(handle);
while ischar(l)
    if strncmp(l, prefix, prefix_length)
        t = sscanf(l, [prefix '%f']);
        break
    end
    l = fgetl(handle);
end
fclose(handle);

end

