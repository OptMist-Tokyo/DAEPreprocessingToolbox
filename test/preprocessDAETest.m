classdef preprocessDAETest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            [newEqs, newVars, value] = preprocessDAE(zeros(0, 1, 'sym'), zeros(1, 0, 'sym'));
            testCase.verifyEqual(newEqs, zeros(0, 1, 'sym'));
            testCase.verifyEqual(newVars, zeros(1, 0, 'sym'));
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
