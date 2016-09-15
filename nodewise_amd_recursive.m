% NODEWISE_AMD_RECURSIVE Nodewise elimination procedure: recursive AMD as
% defined in Rommes and Schilders publication.
%
% See also NODEWISE_ABSTRACT.
function reduced_data = nodewise_amd_recursive( G, is_ext_node, options )

reorder_function = @amd;
reduced_data = struct;

nodewise__recursive;

reduced_data.G = bestG;
reduced_data.new_nodes = local_nodes_left;
reduced_data.is_ext_node = is_ext_node(local_nodes_left);
reduced_data.eliminated_nodes = local_nodes_eliminated;
reduced_data.early_exit = early_exit;
reduced_data.fillin_tracker = local_fillin_tracker;

end
