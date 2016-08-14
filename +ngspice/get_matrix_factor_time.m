function n = get_matrix_factor_time( log_file )
n = ngspice.get__value_from_log(log_file, 'Matrix factor time = ', '%f');
end
