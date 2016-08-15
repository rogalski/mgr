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
netlists.dump_header(handle);
n_circuits = length(varargin) / 3;
r_count = uint32(0);
v_count = uint32(0);
for k=1:n_circuits
    [G, is_ext_node, node_ids] = varargin{3*k-2:3*k};
    fprintf(handle,'* Connected component %d\n', k);
    r_count = netlists.dump_conductance_matrix(handle, G, node_ids, r_count);
    v_count = netlists.dump_sources(handle, is_ext_node, node_ids, v_count);
end
netlists.dump_footer(handle, varargin{3});
fclose(handle);
end
