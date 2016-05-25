function dump_footer( handle )
fprintf(handle, '.op\n');
fprintf(handle, '.dc V1 0 1 10m\n');
fprintf(handle, '.plot dc v(1)\n');
fprintf(handle, '.end\n');
end
