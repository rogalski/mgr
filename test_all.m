import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin

% This is rather unscallable - refactoring may be needed
s1 = TestSuite.fromFile('test_circuit_info.m');
s2 = TestSuite.fromFile('test_graph_reduce.m');
s3 = TestSuite.fromClass(?test_netlists);
s4 = TestSuite.fromFile('test_nesdis_custom_algorithm.m');
suite = [s1, s2, s3, s4];

runner = TestRunner.withTextOutput;
runner.addPlugin(CodeCoveragePlugin.forFolder(pwd))
runner.addPlugin(CodeCoveragePlugin.forFolder(fullfile(pwd, '+netlists')))
runner.addPlugin(CodeCoveragePlugin.forFolder(fullfile(pwd, '+dotfiles')))
runner.run(suite);
