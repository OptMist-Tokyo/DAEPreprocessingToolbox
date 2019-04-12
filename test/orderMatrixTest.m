classdef orderMatrixTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            actSolution = orderMatrix(zeros(0, 1, 'sym'), zeros(1, 0, 'sym'));
            expSolution = [];
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function test1(testCase)
            syms x(t) y(t) f(t)
            F = [
                x(t)^2 + diff(x(t))^2 + y(t)
                diff(x(t)) + y(t) + diff(y(t), 5) + f(t)
            ];
            actSolution = orderMatrix(F, [x(t), y(t)]);
            expSolution = [1 0; 1 5];
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function test2(testCase)
            syms x(t) y(t)
            actSolution = orderMatrix([x(t); 0], [x, y]);
            expSolution = [0 -Inf; -Inf -Inf];
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
end
