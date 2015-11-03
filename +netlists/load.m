function [ G, I ] = load( file )
n = netlists.get_node_count(file);
G = sparse(n, n);
I = sparse(n,1);


handle = fopen(file);
tline = fgetl(handle);
while ischar(tline)
    % TODO: Implement parser
    % Figure out node count to allocate memory correctly
    disp(tline)
    tline = fgetl(handle);
end
fclose(handle);

end

