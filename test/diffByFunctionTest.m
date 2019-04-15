classdef diffByFunctionTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            actSolution = diffByFunction(zeros(0, 1, 'sym'), zeros(1, 0, 'sym'));
            expSolution = zeros(0, 'sym');
            testCase.verifyEqual(actSolution, expSolution);
        end

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
        
        function test3(testCase)
            syms y(t) z(t)
            actSolution = diffByFunction([y(t) * diff(y(t)) + z(t); diff(y(t))^2 + diff(z(t), 2) - y(t)], [diff(y), diff(z, 2)]);
            expSolution = [y(t), 0; 2*diff(y(t), t), 1];
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
end
