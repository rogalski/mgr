import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin

% This is rather unscallable - refactoring may be needed
s1 = TestSuite.fromFile('test_circuit_info.m');
s2 = TestSuite.fromFile('test_graph_reduce.m');
s3 = TestSuite.fromClass(test_netlists);
suite = [s1, s2, s3];

runner = TestRunner.withTextOutput;
runner.addPlugin(CodeCoveragePlugin.forFolder(pwd))
runner.run(suite);
