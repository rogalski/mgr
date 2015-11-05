function [ G ] = load( file )
resistor_values = [];
resistor_nodes = [];
resistors_count = uint8(0);

handle = fopen(file);
line = fgetl(handle);  % Skip first (comment line)

% Load resistors
while ischar(line)
    switch line(1)
        case 'R'
            fields = strsplit(line, ' ');
            node1 = str2double(cell2mat(fields(2)));
            node2 = str2double(cell2mat(fields(3)));
            resistor_nodes(2*resistors_count+1) = node1;
            resistor_nodes(2*resistors_count+2) = node2;
            resistor_values(resistors_count+1) = str2double(cell2mat(fields(4)));
            resistors_count = resistors_count + 1;
        otherwise
            % ignore line
    end
    line = fgetl(handle);
end

% Fill G with resistors
n = max(resistor_nodes);
G = sparse(n, n);
for k=1:length(resistor_values)
    m = resistor_nodes(2*k-1);
    n = resistor_nodes(2*k);
    gk = 1/resistor_values(k);
    if m==0 && n==0
        continue
    elseif m==0
        G(n,n) = G(n,n) + gk;
    elseif n==0
        G(m,m) = G(m,m) + gk;
    else
        G(m,m) = G(m,m) + gk;
        G(n,n) = G(n,n) + gk;
        G(m,n) = G(m,n) - gk;
        G(n,m) = G(n,m) - gk;
    end
end
fclose(handle);
end
