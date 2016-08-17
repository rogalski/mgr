function [output_file] = run_neato(filename, extra_args)
if nargin < 2
    extra_args = '';
end
output_file = graphviz.run__gv_cmd('neato', filename, extra_args);
end
