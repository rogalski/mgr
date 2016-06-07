function dump_footer( handle )
fprintf(handle, '.dc V1 0 1 10m\n');
fprintf(handle, '.print dc I(V1)\n');
fprintf(handle, '.print dc I(V2)\n');
fprintf(handle, '.end\n');
end
