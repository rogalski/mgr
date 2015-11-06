function tests = test_netlists
tests = functiontests(localfunctions);
end

function testLoadRBasic(testCase)
expected = sparse([2, -1, 0; -1, 3, -1; 0, -1, 2]);
result = netlists.load('testcases/R_basic.cir');
verifyEqual(testCase,expected,result);
end

function testLoadRBasic2(testCase)
G = [100.1, -100, 0, 0, 0;
    -100, 200, -100, 0, 0;
    0, -100, 101, -1, 0;
    0, 0, -1, 1.1, -0.1;
    0, 0, 0, -0.1, 0.1];
expected = sparse(G);
result = netlists.load('testcases/R_basic2.cir');
verifyEqual(testCase,expected,result,'AbsTol',1e-5);
end

function testLoadDumpLoadRBasic(testCase)
sourceFile = 'testcases/R_basic.cir';
tmpFile = tempname;
G1 = netlists.load(sourceFile);
netlists.dump(tmpFile, G1);
G2 = netlists.load(tmpFile);
verifyEqual(testCase,G1,G2);
delete(tmpFile);
end
