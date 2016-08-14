function n = get_matrix_reorder_time( log_file )
n = ngspice.get__value_from_log(log_file, 'Matrix reorder time = ', '%f');
end
