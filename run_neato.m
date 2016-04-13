function [output_file] = run_neato(filename)
[pathstr,name,~] = fileparts(filename);
output_file = fullfile(pathstr,[name '.png']);
cmdline = strjoin({'/usr/local/bin/neato', filename, '-Tpng', ['-o' output_file]}, ' ');
retcode = system(cmdline);
if retcode ~= 0
    error('neato:call',...,
        '%s retcode: %d',...,
        cmdline, retcode)
end
end
