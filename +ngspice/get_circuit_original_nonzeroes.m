function n = get_circuit_original_nonzeroes( log_file )
n = ngspice.get__value_from_log(log_file, 'Circuit original non-zeroes = ', '%d');
end
