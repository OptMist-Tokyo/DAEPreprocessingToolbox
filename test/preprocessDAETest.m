classdef preprocessDAETest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            eqs = zeros(0, 1, 'sym');
            vars = zeros(0, 1, 'sym');
            [newEqs, newVars, dof, R, constR] = preprocessDAE(eqs, vars);
            testCase.verifyEqual(newEqs, eqs);
            testCase.verifyEqual(newVars, vars);
            testCase.verifyEqual(dof, 0);
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
            testCase.verifyEqual(constR, zeros(0, 2, 'sym'));
        end
        
        function test1(testCase)
            eqs = zeros(0, 1, 'sym');
            vars = zeros(0, 1, 'sym');
            pointKeys = zeros(1, 0, 'sym');
            pointValues = zeros(1, 0);
            [newEqs, newVars, dof, R, constR] = preprocessDAE(eqs, vars, pointKeys, pointValues);
            testCase.verifyEqual(newEqs, eqs);
            testCase.verifyEqual(newVars, vars);
            testCase.verifyEqual(dof, 0);
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
            testCase.verifyEqual(constR, zeros(0, 2, 'sym'));
        end
        
        function test2(testCase)
            syms x1(t) x2(t)
            eqs = [
                diff(x1(t))*diff(x2(t)) - 2*cos(t)^2
                diff(x1(t))^2*diff(x2(t))^2 + x1(t) + x2(t) - 4*cos(t)^4 - 3*sin(t) - 2
            ];
            vars = [x1; x2];
            pointKeys = [diff(x1) diff(x2)];
            pointValues = [0 1];
            [newEqs, newVars, dof, R, constR] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'substitution');
            %testCase.verifyEqual(newEqs, [
            %    diff(x1(t))*diff(x2(t)) - 2*cos(t)^2
            %    x1(t) + x2(t) - 3*sin(t) - 2
            %]);
            testCase.verifyEqual(newVars, [x1(t); x2(t)]);
            testCase.verifyEqual(dof, 1);
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
            testCase.verifyEqual(constR, zeros(0, 2, 'sym'));
        end
        
        function test3(testCase)
            syms x1(t) x2(t)
            eqs = [
                diff(x1(t))*diff(x2(t)) - 2*cos(t)^2
                diff(x1(t))^2*diff(x2(t))^2 + x1(t) + x2(t) - 4*cos(t)^4 - 3*sin(t) - 2
            ];
            vars = [x1; x2];
            pointKeys = [diff(x1) diff(x2)];
            pointValues = [0 1];
            [newEqs, newVars, dof, R, constR, newPointKeys, newPointValues] ...
                = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'sym');
            
            syms Dx1t(t) constDx2t
            testCase.verifyEqual(newEqs, [
                diff(x1(t))*diff(x2(t)) - 2*cos(t)^2
                x1(t) - 3*sin(t) + x2(t) - 4*cos(t)^4 + constDx2t^2*Dx1t(t)^2 - 2
                constDx2t*Dx1t(t) - 2*cos(t)^2
            ]);
            testCase.verifyEqual(newVars, [x1(t); x2(t); Dx1t(t)]);
            testCase.verifyEqual(dof, 1);
            testCase.verifyEqual(R, [Dx1t(t), diff(x1(t))]);
            testCase.verifyEqual(constR, [constDx2t, diff(x2(t))]);
            testCase.verifyEqual(newPointKeys, [diff(x1(t), t), diff(x2(t), t), Dx1t(t), constDx2t]);
            testCase.verifyEqual(newPointValues, [0 1 0 1]);
        end
        
        function pendulum(testCase)
            [eqs, vars, pointKeys, pointValues] = problem.pendulum;
            dof = 2;
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'substitution');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'substitution');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation');
            testCase.verifyEqual(value, dof);
        end
        
        function modifiedPendulum(testCase)
            [eqs, vars, pointKeys, pointValues] = problem.modifiedPendulum;
            dof = 2;
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'substitution');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'substitution');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation', 'Constants', 'sym');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation', 'Constants', 'zero');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'sym');
            testCase.verifyEqual(value, dof);
            %[~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'zero');
            %testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'point');
            testCase.verifyEqual(value, dof);
        end
        
        function roboticArm(testCase)
            [eqs, vars, pointKeys, pointValues] = problem.roboticArm;
            dof = 0;
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'substitution');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'substitution');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation', 'Constants', 'sym');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation', 'Constants', 'zero');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'sym');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'zero');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'point');
            testCase.verifyEqual(value, dof);
        end
        
        function transistorAmplifier(testCase)
            [eqs, vars, pointKeys, pointValues] = problem.transistorAmplifier;
            dof = 5;
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'substitution');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'substitution');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation', 'Constants', 'sym');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation', 'Constants', 'zero');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'sym');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'zero');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'point');
            testCase.verifyEqual(value, dof);
        end
        
        function ringModulator(testCase)
            [eqs, vars, pointKeys, pointValues] = problem.ringModulator;
            dof = 10;
            %[~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'substitution');
            %testCase.verifyEqual(value, dof);
            %[~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'substitution');
            %testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation', 'Constants', 'sym');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, 'Method', 'augmentation', 'Constants', 'zero');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'sym');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'zero');
            testCase.verifyEqual(value, dof);
            [~, ~, value] = preprocessDAE(eqs, vars, pointKeys, pointValues, 'Method', 'augmentation', 'Constants', 'point');
            testCase.verifyEqual(value, dof);
        end
    end
end
