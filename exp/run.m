addpath('src', 'test');

genData;

function genData
    fprintf('\n--------\nModified Pendulum\n--------\n');
    [eqs, vars, pointKeys, pointValues, tspan] = modifiedPendulum;
    fprintf('- none:\n');
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'none', true, "pendulum_none");
    fprintf('- sub:\n');
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'substitution', true, "pendulum_sub");
    fprintf('- aug:\n');
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'augmentation', true, "pendulum_aug");

    fprintf('\n--------\nRobotic Arm\n--------\n');
    [eqs, vars, pointKeys, pointValues, tspan] = roboticArm;
    fprintf('- none:\n');
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'none', true, "robot_none");
    fprintf('- sub:\n');
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'substitution', true, "robot_sub");
    fprintf('- aug:\n');
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'augmentation', true, "robot_aug");

    fprintf('\n--------\nTransistor Amplifier\n--------\n');
    [eqs, vars, pointKeys, pointValues, tspan] = transistorAmplifier;
    fprintf('- none:\n');
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'none', true, "transamp_none");
    fprintf('- sub:\n');
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'substitution', true, "transamp_sub");
    fprintf('- aug:\n');
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'augmentation', false, "transamp_aug");

    fprintf('\n--------\nRing Modulator\n--------\n');
    [eqs, vars, pointKeys, pointValues, tspan] = ringModulator;
    fprintf('- none:\n');
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'none', false, "ringmod_none");
    %fprintf('- sub:\n');
    %experiment(eqs, vars, pointKeys, pointValues, tspan, 'substitution', false, "ringmod_sub");
    fprintf('- aug:\n');
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'augmentation', false, "ringmod_aug");
end


function [eqs, vars, pointKeys, pointValues, tspan] = pendulum
    [eqs, vars, pointKeys, pointValues] = problem.pendulum;
    tspan = [0, 5];
end

function [eqs, vars, pointKeys, pointValues, tspan] = modifiedPendulum
    [eqs, vars, pointKeys, pointValues] = problem.modifiedPendulum;
    tspan = [0, 5];
end

function [eqs, vars, pointKeys, pointValues, tspan] = roboticArm
    [eqs, vars, pointKeys, pointValues] = problem.roboticArm;
    tspan = [0, 1.4];
end

function [eqs, vars, pointKeys, pointValues, tspan] = transistorAmplifier
    [eqs, vars, pointKeys, pointValues] = problem.transistorAmplifier;
    tspan = [0, 0.2];
end

function [eqs, vars, pointKeys, pointValues, tspan] = ringModulator
    [eqs, vars, pointKeys, pointValues] = problem.ringModulator;
    tspan = [0, 1e-3];
end
