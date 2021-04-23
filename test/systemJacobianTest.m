classdef systemJacobianTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            [D, p, q] = systemJacobian(zeros(0, 1, 'sym'), zeros(1, 0, 'sym'));
            testCase.verifyEqual(D, zeros(0, 0, 'sym'));
            testCase.verifyEqual(p, zeros(1, 0));
            testCase.verifyEqual(q, zeros(1, 0));
        end
        
        function test1(testCase)
            syms y(t) z(t) f(t)
            F = [
                z(t)^2 + diff(z(t))^2 + y(t) + diff(f(t), 3)
                diff(z(t)) + y(t) + diff(y(t), 5) + f(t)
            ];
            x = [z, y];
            [D, p, q] = systemJacobian(F, x);
            testCase.verifyEqual(D, [2*diff(z(t), t), 0; 1, 1]);
            testCase.verifyEqual(p, zeros(1, 2));
            testCase.verifyEqual(q, [1, 5]);
        end
        
        function test2(testCase)
            syms Dys(s) y(s)
            F = [
                Dys(s) + diff(y(s))
                y(s)
            ];
            x = [Dys, y];
            [D, p, q] = systemJacobian(F, x);
            testCase.verifyEqual(D, sym([1 1; 0 1]));
            testCase.verifyEqual(p, [0, 1]);
            testCase.verifyEqual(q, [0, 1]);
        end
    end
end
