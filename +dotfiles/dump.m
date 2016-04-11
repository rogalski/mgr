function dump(filename, G, ExtNodes, run_neato)
handle = fopen(filename, 'W');
fprintf(handle,'graph circuit {\n overlap=false \n');
fprintf(handle,'node [shape=circle];\n');
fprintf(handle,'{ node [shape=rect] ');

for k=ExtNodes
    fprintf(handle,'%i ', k);
end
fprintf(handle, '}\n');

dotfiles.dump_conductance_matrix(G, handle);
fprintf(handle,'}\n');
fclose(handle);

if ~exist('run_neato','var') 
    run_neato = 0;
end

% run neato if requested
if (run_neato)
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
end
