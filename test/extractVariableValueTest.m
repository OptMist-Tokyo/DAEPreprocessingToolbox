classdef extractVariableValueTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            [y, yp] = extractVariableValue(zeros(1, 0, 'sym'), zeros(1, 0, 'sym'), zeros(1, 0));
            testCase.verifyEqual(y, zeros(1, 0));
            testCase.verifyEqual(yp, zeros(1, 0));
        end

        function test1(testCase)
            syms x1(t) x2(t) x3(t) x4(t) x5(t)
            vars = [x1, x2, x3, x4, x5];
            pointKeys = [x1, x2, x3, x4, x5, diff(x1), diff(x2), diff(x3), diff(x4), diff(x5)];
            pointValues = [0.5, 8.5311195044981, 3.2432815053528, 0, 0, 0, 0, 0, -4.2435244785437, -2.45];
            [y, yp] = extractVariableValue(vars, pointKeys, pointValues);
            testCase.verifyEqual(y, pointValues(1:5));
            testCase.verifyEqual(yp, pointValues(6:10));
        end
    end
end
