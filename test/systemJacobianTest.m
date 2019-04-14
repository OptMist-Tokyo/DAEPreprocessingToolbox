classdef systemJacobianTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            actSolution = systemJacobian(zeros(0, 1, 'sym'), zeros(1, 0, 'sym'), zeros(0, 1), zeros(1, 0));
            expSolution = zeros(0, 0, 'sym');
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function test1(testCase)
            syms xxx(t) y(t) f(t)
            F = [
                xxx(t)^2 + diff(xxx(t))^2 + y(t) + diff(f(t), 3)
                diff(xxx(t)) + y(t) + diff(y(t), 5) + f(t)
            ];
            x = [xxx, y];
            p = [0; 0];
            q = [1, 5];
            actSolution = systemJacobian(F, x, p, q);
            expSolution = [2*diff(xxx(t), t), 0; 1, 1];
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function test2(testCase)
            syms y(s) z(s)
            F = [
                y(s) + diff(z(s))
                z(s)
            ];
            x = [y, z];
            p = [0; 1];
            q = [0, 1];
            actSolution = systemJacobian(F, x, p, q);
            expSolution = sym([1 1; 0 1]);
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
end
