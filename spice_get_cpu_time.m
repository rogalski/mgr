function t = spice_get_cpu_time( log_file )
%SPICE_GET_CPU_TIME Retrieves cpu time from ngspice log file.
prefix = 'Total CPU time: ';
prefix_length = length(prefix);

handle = fopen(log_file);
fseek(handle, -512, 'eof');

l = fgetl(handle);
while ischar(l)
    if strncmp(l, prefix, prefix_length)
        t = sscanf(l, 'Total CPU time: %f');
        break
    end
    l = fgetl(handle);
end
fclose(handle);

end

