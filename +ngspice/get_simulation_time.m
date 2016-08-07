function t = get_simulation_time( log_file )
t = ngspice.get__value_from_log(log_file, 'Total analysis time = ', '%f');
end
