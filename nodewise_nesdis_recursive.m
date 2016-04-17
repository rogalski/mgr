% NODEWISE_NESDIS_RECURSIVE Nodewise elimination procedure: recursive
% nesdis. Inspiried by Rommes and Schilders strategy for AMD, but used for
% nested dissection.
%
% See also NODEWISE_ABSTRACT.
function reduced_data = nodewise_nesdis_recursive( G, is_ext_node, ~ )

reorder_function = @nesdis;
reduced_data = struct;

nodewise__recursive;

reduced_data.G = bestG;
reduced_data.new_nodes = local_nodes_left;
reduced_data.is_ext_node = is_ext_node(local_nodes_left);
reduced_data.eliminated_nodes = local_nodes_eliminated;
reduced_data.early_exit = early_exit;
reduced_data.fillin_tracker = local_fillin_tracker;

end
