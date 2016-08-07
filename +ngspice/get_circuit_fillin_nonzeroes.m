function n = get_circuit_fillin_nonzeroes( log_file )
n = ngspice.get__value_from_log(log_file, 'Circuit fill-in non-zeroes = ', '%d');
end
