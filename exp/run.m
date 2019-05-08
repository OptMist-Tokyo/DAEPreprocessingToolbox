addpath('src', 'test');

genData


function genData
    disp('Modified Pendulum');
    [eqs, vars, pointKeys, pointValues, tspan] = modifiedPendulum;
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'none', true, "pendulum_none");
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'substitution', true, "pendulum_sub");
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'augmentation', true, "pendulum_aug");

    disp('Robotic Arm');
    [eqs, vars, pointKeys, pointValues, tspan] = roboticArm;
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'none', true, "robot_none");
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'substitution', true, "robot_sub");
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'augmentation', true, "robot_aug");

    disp('Transistor Amplifier');
    [eqs, vars, pointKeys, pointValues, tspan] = transistorAmplifier;
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'none', true, "transamp_none");
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'substitution', true, "transamp_sub");
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'augmentation', false, "transamp_aug");

    disp('Ring Modulator');
    [eqs, vars, pointKeys, pointValues, tspan] = ringModulator;
    experiment(eqs, vars, pointKeys, pointValues, tspan, 'none', false, "ringmod_none");
    %experiment(eqs, vars, pointKeys, pointValues, tspan, 'substitution', false, "ringmod_sub");
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
