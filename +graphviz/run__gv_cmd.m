function [output_file] = run__gv_cmd(cmd, filename, extra_args)
if nargin < 3
    extra_args = '';
end
[pathstr,name,~] = fileparts(filename);
output_file = fullfile(pathstr,[name '.eps']);
cmdline = strjoin({['/usr/local/bin/' cmd], extra_args, filename, '-Teps', ['-o' output_file]}, ' ');
retcode = system(cmdline);
if retcode ~= 0
    error([cmd ':call'], ...,
        '%s retcode: %d',...,
        cmdline, retcode)
end
end
