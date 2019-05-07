classdef preprocessDAETest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            eqs = zeros(0, 1, 'sym');
            vars = zeros(0, 1, 'sym');
            [newEqs, newVars, value] = preprocessDAE(eqs, vars);
            testCase.verifyEqual(newEqs, eqs);
            testCase.verifyEqual(newVars, vars);
            testCase.verifyEqual(value, 0);
        end
        
        function test1(testCase)
            eqs = zeros(0, 1, 'sym');
            vars = zeros(0, 1, 'sym');
            pointKeys = zeros(1, 0, 'sym');
            pointValues = zeros(1, 0);
            [newEqs, newVars, value] = preprocessDAE(eqs, vars, pointKeys, pointValues);
            testCase.verifyEqual(newEqs, eqs);
            testCase.verifyEqual(newVars, vars);
            testCase.verifyEqual(value, 0);
        end
        
        function pendulum(testCase)
            [eqs, vars] = problem.pendulum;
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'substitution');
            testCase.verifyEqual(value, 2);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation');
            testCase.verifyEqual(value, 2);
        end
        
        function modifiedPendulum(testCase)
            [eqs, vars, pointKeys, pointValues] = problem.modifiedPendulum;
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'substitution');
            testCase.verifyEqual(value, 2);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'substitution');
            testCase.verifyEqual(value, 2);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation');
            testCase.verifyEqual(value, 2);
        end
        
        function roboticArm(testCase)
            [eqs, vars, pointKeys, pointValues] = problem.roboticArm;
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'substitution');
            testCase.verifyEqual(value, 0);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'substitution');
            testCase.verifyEqual(value, 0);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation');
            testCase.verifyEqual(value, 0);
        end
        
        function transistorAmplifier(testCase)
            [eqs, vars, pointKeys, pointValues] = problem.transistorAmplifier;
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'substitution');
            testCase.verifyEqual(value, 5);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'substitution');
            testCase.verifyEqual(value, 5);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation');
            testCase.verifyEqual(value, 5);
        end
        
        function ringModulator(testCase)
            [eqs, vars, pointKeys, pointValues] = problem.ringModulator;
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation');
            testCase.verifyEqual(value, 10);
        end
    end
end
