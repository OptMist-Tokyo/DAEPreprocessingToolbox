addpath('src', 'test');

[eqs, vars, pointKeys, pointValues, tspan] = ringModulator;
experiment(eqs, vars, pointKeys, pointValues, tspan, 'augmentation', false, "ringmod_aug");


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
    syms g m L t;
    params = [g m L];
    [eqs, vars, pointKeys, pointValues] = problem.pendulum;
    eqs = subs(eqs, params, substitutePoint(params, pointKeys, pointValues));
    tspan = [0, 5];
    vars = vars(t);
    pointKeys = pointKeys(t);
end


function [eqs, vars, pointKeys, pointValues, tspan] = modifiedPendulum
    [eqs, vars, pointKeys, pointValues] = problem.modifiedPendulum;
    eqs = subs(eqs, sym('g'), 9.8);
    tspan = [0, 5];
    syms t
    vars = vars(t);
    pointKeys = pointKeys(t);
end


function [eqs, vars, pointKeys, pointValues, tspan] = roboticArm
    [eqs, vars, pointKeys, pointValues] = problem.roboticArm;
    tspan = [0, 1.4];
    syms t
    vars = vars(t);
    pointKeys = pointKeys(t);
end


function [eqs, vars, pointKeys, pointValues, tspan] = transistorAmplifier
    syms C1 C2 C3 C4 C5 R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 alph bet Ub UF
    params = [C1 C2 C3 C4 C5 R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 alph bet Ub UF];
    [eqs, vars, pointKeys, pointValues] = problem.transistorAmplifier;
    eqs = subs(eqs, params, substitutePoint(params, pointKeys, pointValues));
    tspan = [0, 0.2];
    syms t
    vars = vars(t);
    pointKeys = pointKeys(t);
end


function [eqs, vars, pointKeys, pointValues, tspan] = ringModulator
    syms C Cp Lh Ls1 Ls2 Ls3 gam R Rp Rg1 Rg2 Rg3 Ri Rc del
    params = [C Cp Lh Ls1 Ls2 Ls3 gam R Rp Rg1 Rg2 Rg3 Ri Rc del];
    [eqs, vars, pointKeys, pointValues] = problem.ringModulator;
    eqs = subs(eqs, params, substitutePoint(params, pointKeys, pointValues));
    tspan = [0, 1e-3];
    syms t
    vars = vars(t);
    pointKeys = pointKeys(t);
end
