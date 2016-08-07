function v = get__value_from_log( log_file, prefix, type )

prefix_length = length(prefix);
handle = fopen(log_file);

l = fgetl(handle);
while ischar(l)
    if strncmp(l, prefix, prefix_length)
        v = sscanf(l, [prefix type]);
        break
    end
    l = fgetl(handle);
end
fclose(handle);

end
