function n = get_circuit_total_nonzeroes( log_file )
n = ngspice.get__value_from_log(log_file, 'Circuit total non-zeroes = ', '%d');
end
