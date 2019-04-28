classdef systemJacobianTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            actSolution = systemJacobian(zeros(0, 1, 'sym'), zeros(1, 0, 'sym'));
            expSolution = zeros(0, 0, 'sym');
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function test1(testCase)
            syms z(t) y(t) f(t)
            F = [
                z(t)^2 + diff(z(t))^2 + y(t) + diff(f(t), 3)
                diff(z(t)) + y(t) + diff(y(t), 5) + f(t)
            ];
            x = [z, y];
            actSolution = systemJacobian(F, x, p, q);
            expSolution = [2*diff(z(t), t), 0; 1, 1];
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function test2(testCase)
            syms Dys(s) y(s)
            F = [
                Dys(s) + diff(y(s))
                y(s)
            ];
            x = [Dys, y];
            actSolution = systemJacobian(F, x, p, q);
            expSolution = sym([1 1; 0 1]);
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
end
