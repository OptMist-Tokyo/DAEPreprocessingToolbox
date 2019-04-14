classdef diffByFunctionTest < matlab.unittest.TestCase
    methods (Test)
        function test1(testCase)
            syms y(t)
            actSolution = diffByFunction(y(t)^2, y(t));
            expSolution = 2*y(t);
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function test2(testCase)
            syms y(t)
            actSolution = diffByFunction([y(t) * diff(y(t)) == 0; diff(y(t))^2 == y(t)], diff(y(t)));
            expSolution = [y(t) == 0; 2*diff(y(t), t) == 0];
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
end
