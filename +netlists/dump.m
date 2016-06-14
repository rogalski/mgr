function dump(filename, G, is_ext_node, node_ids)
% DUMP  Dumps conductance matrix as Spice *.cir file.
% 
% Input:
%   filename - name of file where dump should be made
%   G - conductance matrix of dumped circuit
%   is_ext_node - boolean vector denoting external nodes in G
%   node_ids - optional vector of ids used to rename nodes accordingly
%


if (~exist('node_ids', 'var'))
    node_ids = 1:length(G);
end

handle = fopen(filename, 'W');
if handle == -1
   error('Failed to open %s for writing', filename) 
end
netlists.dump_header(handle);
netlists.dump_conductance_matrix(handle, G, node_ids, uint32(0));
netlists.dump_sources(handle, is_ext_node, node_ids, uint32(0));
netlists.dump_footer(handle, node_ids);
fclose(handle);
end
