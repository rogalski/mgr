function [output_file] = run_fdp(filename, extra_args)
if nargin < 2
    extra_args = '';
end
output_file = graphviz.run__gv_cmd('fdp', filename, extra_args);
end
