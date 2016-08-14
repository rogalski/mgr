function n = get_matrix_load_time( log_file )
n = ngspice.get__value_from_log(log_file, 'Matrix load time = ', '%f');
end
