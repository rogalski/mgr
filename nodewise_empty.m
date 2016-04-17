% NODEWISE_DUMMY Nodewise elimination procedure: null operation.
%
% See also NODEWISE_ABSTRACT.
function reduced_data = nodewise_empty( G, is_ext_node, ~ )
    reduced_data = struct;
    reduced_data.G = G;
    reduced_data.new_nodes = 1:length(G);
    reduced_data.is_ext_node = is_ext_node;
    reduced_data.eliminated_nodes = [];
    reduced_data.early_exit = 0;
    reduced_data.fillin_tracker = [];
end
