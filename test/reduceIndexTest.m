classdef reduceIndexTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            eqs = zeros(0, 1, 'sym');
            vars = zeros(0, 1, 'sym');
            pointKeys = zeros(1, 0, 'sym');
            pointValues = zeros(1, 0);
            [newEqs, newVars, R, newPointKeys, newPointValues] = reduceIndex(eqs, vars, pointKeys, pointValues);
            testCase.verifyEqual(newEqs, eqs);
            testCase.verifyEqual(newVars, vars);
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
            testCase.verifyEqual(newPointKeys, pointKeys);
            testCase.verifyEqual(newPointValues, pointValues);
        end
        
        function test1(testCase)
            syms y(t)
            eqs = y(t);
            vars = y;
            [newEqs, newVars, R] = reduceIndex(eqs, vars);
            testCase.verifyEqual(newEqs, y(t));
            testCase.verifyEqual(newVars, y(t));
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
        end
        
        function test2(testCase)
            [eqs, vars] = problem.pendulum;
            [newEqs, newVars, R] = reduceIndex(eqs, vars);
            
            syms y(t) z(t) T(t) Dyt(t) Dytt(t)
            syms g m L
            testCase.verifyEqual(newEqs, [
                m*Dytt(t) - y(t)*T(t)/L
                m*diff(z(t), 2) - z(t)*T(t)/L + m*g
                y(t)^2 + z(t)^2 - L^2
                2*Dyt(t)*y(t) + 2*z(t)*diff(z(t))
                2*Dytt(t)*y(t) + 2*Dyt(t)^2 + 2*diff(z(t))^2 + 2*z(t)*diff(z(t), 2)
            ]);
            testCase.verifyEqual(newVars, [y(t); z(t); T(t); Dyt(t); Dytt(t)]);
            testCase.verifyEqual(R, [
                diff(y(t)) Dyt(t)
                diff(y(t), 2) Dytt(t)
            ]);
        end
        
        function test3(testCase)
            [eqs, vars, pointKeys, pointValues] = problem.pendulum;
            [newEqs, newVars, R, newPointKeys, newPointValues] = reduceIndex(eqs, vars, pointKeys, pointValues);
            
            syms y(t) z(t) T(t) Dzt(t) Dztt(t)
            syms g m L
            testCase.verifyEqual(newEqs, [
                m*diff(y(t), 2) - y(t)*T(t)/L
                m*Dztt(t) - z(t)*T(t)/L + m*g
                y(t)^2 + z(t)^2 - L^2
                2*Dzt(t)*z(t) + 2*y(t)*diff(y(t))
                2*Dztt(t)*z(t) + 2*Dzt(t)^2 + 2*diff(y(t))^2 + 2*y(t)*diff(y(t), 2)
            ]);
            testCase.verifyEqual(newVars, [y(t); z(t); T(t); Dzt(t); Dztt(t)]);
            testCase.verifyEqual(R, [
                diff(z(t)) Dzt(t)
                diff(z(t), 2) Dztt(t)
            ]);
            testCase.verifyEqual(newPointKeys, [pointKeys(t) Dzt(t) Dztt(t)]);
            %testCase.verifyEqual(newPointValues, [pointValues 0 -2.45]);
        end
    end
end
