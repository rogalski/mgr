import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin

s1 = TestSuite.fromFile('test_circuit_info.m');
s2 = TestSuite.fromFile('test_graph_reduce.m');
suite = [s1, s2];

runner = TestRunner.withTextOutput;
runner.addPlugin(CodeCoveragePlugin.forFolder(pwd))
runner.run(suite);
