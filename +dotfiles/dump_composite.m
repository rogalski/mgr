function dump_composite(filename, varargin)
% DUMP_COMPOSITE  Dumps multiple conductance matrices as Graphviz *.dot file.
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
dotfiles.dump_header(handle);

r_count = uint32(0);

n_circuits = length(varargin) / 3;
for k=1:n_circuits
    [G, is_ext_node, node_ids] = varargin{3*k-2:3*k};
    dotfiles.dump_terminals(handle, is_ext_node, node_ids);
    dotfiles.dump_conductance_matrix(handle, G, node_ids);
end

fprintf(handle,'}\n');
fclose(handle);

end
