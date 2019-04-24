classdef daeJacobianFunctionTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            jac = daeJacobianFunction(zeros(0, 1, 'sym'), zeros(1, 0, 'sym'));
            [J, JP] = jac(0, 0, 0);
            testCase.verifyEqual(J, 0);
            testCase.verifyEqual(JP, 0);
        end
        
        function test1(testCase)
            syms y(t)
            jac = daeJacobianFunction(t*y(t) + 2*diff(y(t)), y);
            [J, JP] = jac(1, 2, 3);
            testCase.verifyEqual(J, 1);
            testCase.verifyEqual(JP, 2);
        end

        function test2(testCase)
            syms y(t) z(t)
            jac = daeJacobianFunction([y(t)^2 + z(t)^2, diff(y(t))^2 + diff(z(t))^2], [y, z]);
            [J, JP] = jac(1, [2; 3], [4; 5]);
            testCase.verifyEqual(J, [4 6; 0 0]);
            testCase.verifyEqual(JP, [0 0; 8 10]);
        end
    end
end
