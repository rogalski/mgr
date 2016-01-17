function [log_file] = spice(input_file)
spice_path = '/Applications/LTspice.app/Contents/MacOS/LTspice';
cmdline = strjoin({spice_path, '-b', input_file}, ' ');
retcode = system(cmdline);
if retcode ~= 0
    error('spice:call',...,
        '%s retcode: %d',...,
        cmdline, retcode)
end
[pathstr,name,~] = fileparts(input_file);
log_file = fullfile(pathstr,[name '.log']);
end
