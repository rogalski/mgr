function N = get_node_count( file )
known_nodes = [];
handle = fopen(file);
line = fgetl(handle);

while ischar(line)
    if ~isempty(line)
        switch line(1)
            % TODO: reduce copied code
            case 'R'
                fields = strsplit(line, ' ');
                node1 = cell2mat(fields(2));
                node2 = cell2mat(fields(3));
                known_nodes(end+1) = node1;
                known_nodes(end+1) = node2;
            case 'I'
                fields = strsplit(line, ' ');
                node1 = cell2mat(fields(2));
                node2 = cell2mat(fields(3));
                known_nodes(end+1) = node1;
                known_nodes(end+1) = node2;
            otherwise
                % ignore line
        end
    end
    line = fgetl(handle);
end
N = length(unique(known_nodes)) - 1;
end
