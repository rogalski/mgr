function [output_file] = run_spice(input_file)
[pathstr,name,~] = fileparts(input_file);
output_file = fullfile(pathstr,[name '.log']);

spice_path = '/usr/local/bin/ngspice';
cmdline = strjoin({spice_path, '-b', input_file, '-o', output_file}, ' ');
retcode = system(cmdline);
if retcode ~= 0
    error('spice:call',...,
        '%s retcode: %d',...,
        cmdline, retcode)
end
end
