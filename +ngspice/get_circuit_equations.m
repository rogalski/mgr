function n = get_circuit_equations( log_file )
n = ngspice.get__value_from_log(log_file, 'Circuit Equations = ', '%d');
end
