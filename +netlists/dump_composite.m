function dump_composite(filename, varargin)
% DUMP_COMPOSITE  Dumps multiple conductance matrices as Spice *.cir file.
% 
% Input:
%   filename - name of file where dump should be made
%   Triplets of (G, is_ext_node, node_ids), where:
%     G - conductance matrix of dumped circuit
%     is_ext_node - boolean vector denoting external nodes in G
%     node_ids - vector of ids used to rename nodes accordingly
%
% See also dump.
%

handle = fopen(filename, 'W');
fprintf(handle,'%% Netlist dump from %s\n', datestr(datetime));
n_circuits = length(varargin) / 3;
r_count = uint32(0);
for k=1:n_circuits
    G = varargin{3*k-2};
    % is_ext_node = varargin{3*k-1};
    node_ids = varargin{3*k};
    r_count = netlists.dump_conductance_matrix(handle, G, node_ids, r_count);
end
fclose(handle);
end
