function n = get_matrix_solve_time( log_file )
n = ngspice.get__value_from_log(log_file, 'Matrix solve time = ', '%f');
end
