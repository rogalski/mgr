function dump_footer( handle, node_ids )
fprintf(handle, '.dc V1 0 1 10m\n');
fprintf(handle, '.print dc v(%d)\n', node_ids(1));
fprintf(handle, '.end\n');
fprintf(handle, '.control\n');
fprintf(handle, 'run\n');
fprintf(handle, 'rusage all\n');
fprintf(handle, '.endc\n');
end
