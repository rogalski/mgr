% Tests for custom reduction scheme based on nesdis partitioning.
Gn = [2 -1 0 0;
      -1 3 -1 0;
      0 -1 3 -1;
      0 0 -1 2];
Zn = zeros(4,4);
G = [Gn, Zn, -ones(4,1);
     Zn, Gn, -ones(4,1);
     -ones(1, 8), 8];
is_ext_node = [0 1 1 0 0 1 1 0 0]';

%% Test: simple_tree
% Easily dividable graph - single node (9) may be separator.
% Set nesdis params to force single parent with single node
options = struct;
options.nesdis_opts = [5, 0, 1, 0];
options.verbose = 0;
output = nodeelim_nesdis_dummy(G, is_ext_node, options);
output.G(1,1) = output.G(1,1) + 1e-5;
assert(check_reduction_correctness(G, is_ext_node, ...
                                   output.G, output.new_nodes) == 1);

%% Test: simple_tree2
% Same graph as above, but with other nesdis params. Force multilevel tree
options = struct;
options.nesdis_opts = [3, 0, 1, 0];
options.verbose = 0;
output = nodeelim_nesdis_dummy(G, is_ext_node, options);
output.G(1,1) = output.G(1,1) + 1e-5;
assert(check_reduction_correctness(G, is_ext_node, ...
                                   output.G, output.new_nodes) == 1);
