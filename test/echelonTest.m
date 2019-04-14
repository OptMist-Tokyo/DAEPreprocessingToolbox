classdef echelonTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            actSolution = echelon(zeros(0, 0, 'sym'));
            expSolution = zeros(0, 0, 'sym');
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function test1(testCase)
            syms x(t) y(t)
            actSolution = echelon([0 x(t) 2*x(t); 0 y(t) 2*y(t); t 0 0]);
            expSolution = [t 0 0; 0 y(t) 2*y(t); 0 0 0];
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function test2(testCase)
            syms x(t) y(t)
            actSolution = echelon([1 x(t) 2*y(t); 0 x(t) 2*y(t); t 0 0]);
            expSolution = [1 0 0; 0 x(t) 2*y(t); 0 0 0];
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
end
