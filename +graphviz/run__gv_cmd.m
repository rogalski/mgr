function [output_file] = run__gv_cmd(cmd, filename, extra_args)
if nargin < 3
    extra_args = '';
end
[pathstr,name,~] = fileparts(filename);
output_file = fullfile(pathstr,[name '.png']);
cmdline = strjoin({['/usr/local/bin/' cmd], extra_args, filename, '-Tpng', ['-o' output_file]}, ' ');
retcode = system(cmdline);
if retcode ~= 0
    error([cmd ':call'], ...,
        '%s retcode: %d',...,
        cmdline, retcode)
end
end
