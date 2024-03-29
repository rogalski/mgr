function tests = test_ngspice
tests = functiontests(localfunctions);
end

function test_get_data_from_circuits(testCase)
expected = 0.064197;
result = ngspice.get_simulation_time(fullfile('unittest_resources', 'ngspice.log'));
testCase.assertEqual(expected, result);
end

function test_get_circuit_equations(testCase)
expected = 2345;
result = ngspice.get_circuit_equations(fullfile('unittest_resources', 'ngspice.log'));
testCase.assertEqual(expected, result);
end

function test_get_circuit_original_nonzeroes(testCase)
expected = 7146;
result = ngspice.get_circuit_original_nonzeroes(fullfile('unittest_resources', 'ngspice.log'));
testCase.assertEqual(expected, result);
end

function test_get_circuit_fillin_nonzeroes(testCase)
expected = 1292;
result = ngspice.get_circuit_fillin_nonzeroes(fullfile('unittest_resources', 'ngspice.log'));
testCase.assertEqual(expected, result);
end

function test_get_circuit_total_nonzeroes(testCase)
expected = 8438;
result = ngspice.get_circuit_total_nonzeroes(fullfile('unittest_resources', 'ngspice.log'));
testCase.assertEqual(expected, result);
end

function test_get_matrix_reorder_time(testCase)
expected = 0.00084;
result = ngspice.get_matrix_reorder_time(fullfile('unittest_resources', 'ngspice.log'));
testCase.assertEqual(expected, result);
end

function test_get_matrix_factor_time(testCase)
expected = 0.009396;
result = ngspice.get_matrix_factor_time(fullfile('unittest_resources', 'ngspice.log'));
testCase.assertEqual(expected, result);
end

function test_get_matrix_solve_time(testCase)
expected = 0.005621;
result = ngspice.get_matrix_solve_time(fullfile('unittest_resources', 'ngspice.log'));
testCase.assertEqual(expected, result);
end

function test_get_matrix_load_time(testCase)
expected = 0.014116;
result = ngspice.get_matrix_load_time(fullfile('unittest_resources', 'ngspice.log'));
testCase.assertEqual(expected, result);
end
