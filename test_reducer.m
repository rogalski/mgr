function tests = test_reducer
tests = functiontests(localfunctions);
end

function testDanglingNetwork(testCase)
G = netlists.load('testcases/dangling_network.cir');
G_org = G;
Terminals = [1, 2];
reducer
% TODO: Assertions
netlists.dump('z1.cir', G);
end

function testDanglingNetwork2(testCase)
G = netlists.load('testcases/dangling_network2.cir');
G_org = G;
Terminals = [1, 2];
reducer
% TODO: Assertions
netlists.dump('z2.cir', G);
end


function testTwoArticulationNodes(testCase)
G = netlists.load('testcases/two_articulation_nodes.cir');
G_org = G;
Terminals = [1, 5];
reducer
% TODO: Assertions
netlists.dump('z2.cir', G);
end
