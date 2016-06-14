function dump_footer( handle )
fprintf(handle, '.dc V1 0 1 1m\n');
fprintf(handle, '.print dc v(1)\n');
fprintf(handle, '.end\n');
fprintf(handle, '.control\n');
fprintf(handle, 'run\n');
fprintf(handle, 'rusage all\n');
fprintf(handle, '.endc\n');
end
