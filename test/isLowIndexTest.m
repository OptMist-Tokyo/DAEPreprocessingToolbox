classdef isLowIndexTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            eqs = zeros(0, 1, 'sym');
            vars = zeros(1, 0, 'sym');
            logic = isLowIndex(eqs, vars);
            testCase.verifyEqual(logic, true);
        end
        
        function test1(testCase)
            syms y(t)
            eqs = y(t);
            vars = y;
            logic = isLowIndex(eqs, vars);
            testCase.verifyEqual(logic, true);
        end
        
        function test2(testCase)
            syms y(t) z(t)
            eqs = [y(t) + diff(z(t)); z(t)];
            vars = [y z];
            logic = isLowIndex(eqs, vars);
            testCase.verifyEqual(logic, false);
        end
        
        function test3(testCase)
            syms y(t) z(t)
            eqs = [diff(y(t)) + diff(z(t), 2); diff(z(t))];
            vars = [y z];
            logic = isLowIndex(eqs, vars);
            testCase.verifyEqual(logic, true);
        end
    end
end
