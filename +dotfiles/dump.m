function dump(filename, G, is_ext_node, node_ids)
% DUMP  Dumps conductance matrix as Graphviz *.dot file.
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
fprintf(handle,'graph circuit {\noverlap=false\n');
fprintf(handle,'node [shape=circle];\n');
fprintf(handle,'{ node [shape=rect] ');

for k=find(is_ext_node)
    fprintf(handle,'%i ', node_ids(k));
end
fprintf(handle, '}\n');

dotfiles.dump_conductance_matrix(handle, G, node_ids);
fprintf(handle,'}\n');
fclose(handle);
end
