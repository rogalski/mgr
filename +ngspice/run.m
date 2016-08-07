function [output_file] = run(input_file)
[pathstr,name,~] = fileparts(input_file);
output_file = fullfile(pathstr,[name '.log']);

MODIFY_NICENESS = 0;
if MODIFY_NICENESS
    proxy = '/usr/bin/nice -n -20';
else
    proxy = '';
end

spice_path = '/usr/local/bin/ngspice';
cmdline = strjoin({proxy, spice_path, '-b', input_file, '-o', output_file}, ' ');
retcode = system([cmdline '> /dev/null']);
if retcode ~= 0
    error('spice:call',...,
        '%s retcode: %d',...,
        cmdline, retcode)
end
end
