classdef test_netlists < matlab.unittest.TestCase
 
    properties
        tmpFileName
    end
 
    methods(TestMethodSetup)
        function createTmpFile(testCase)
            testCase.tmpFileName = tempname;
        end
    end
 
    methods(TestMethodTeardown)
        function deleteTmpFile(testCase)
            delete(testCase.tmpFileName)
        end
    end
    
    methods
        function lines = readResultLines(testCase)
            text = fileread(testCase.tmpFileName);
            lines = strsplit(text, '\n');
        end
        
    end
 
    methods(Test)
        function dumpDefaultNodeNames(testCase)
            G = [1, -1; -1, 1];
            netlists.dump(testCase.tmpFileName, G, [])
            result = testCase.readResultLines();
            % First line should be comment
            testCase.verifyEqual(result{1}(1), '%')
            testCase.verifyEqual(result{2}, 'R1 1 2 1')
        end

        function dumpCustomNodeNames(testCase)
            G = [1.5, -0.5, -1; -0.5, 1, -0.5; -1, -1, 2];
            netlists.dump(testCase.tmpFileName, G, [], 4:6)
            result = testCase.readResultLines();
            % First line should be comment
            testCase.verifyEqual(result{1}(1), '%')
            testCase.verifyEqual(result{2}, 'R1 4 5 2')
            testCase.verifyEqual(result{3}, 'R2 4 6 1')
            testCase.verifyEqual(result{4}, 'R3 5 6 2')
        end

        function dumpComposite(testCase)
            G = [1, -1; -1, 1];
            netlists.dump_composite(testCase.tmpFileName, G, [], 1:2, G, [], 4:5)
            result = testCase.readResultLines();
            % First line should be comment
            testCase.verifyEqual(result{1}(1), '%')
            % Each connected component should be commented
            testCase.verifyEqual(result{2}, '% Connected component 1')
            testCase.verifyEqual(result{3}, 'R1 1 2 1')
            testCase.verifyEqual(result{4}, '% Connected component 2')
            testCase.verifyEqual(result{5}, 'R2 4 5 1')
        end
    end
end
