addpath('src', 'test');

[eqs, vars, pointKeys, pointValues, tspan] = roboticArm;
syms t
vars = vars(t);
pointKeys = pointKeys(t);
experiment(eqs, vars, pointKeys, pointValues, tspan, 'substitution');


function [eqs, vars, pointKeys, pointValues, tspan] = pendulum
    syms g m L;
    params = [g m L];
    [eqs, vars, pointKeys, pointValues] = problem.pendulum;
    eqs = subs(eqs, params, substitutePoint(params, pointKeys, pointValues));
    tspan = [0, 5];
end


function [eqs, vars, pointKeys, pointValues, tspan] = modifiedPendulum
    [eqs, vars, pointKeys, pointValues] = problem.modifiedPendulum;
    eqs = subs(eqs, sym('g'), 9.8);
    tspan = [0, 5];
end


function [eqs, vars, pointKeys, pointValues, tspan] = roboticArm
    [eqs, vars, pointKeys, pointValues] = problem.roboticArm;
    tspan = [0, 1];
end


function [eqs, vars, pointKeys, pointValues, tspan] = transistorAmplifier
    syms C1 C2 C3 C4 C5 R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 alph bet Ub UF
    params = [C1 C2 C3 C4 C5 R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 alph bet Ub UF];
    [eqs, vars, pointKeys, pointValues] = problem.transistorAmplifier;
    eqs = subs(eqs, params, substitutePoint(params, pointKeys, pointValues));
    tspan = [0, 0.2];
end


function [eqs, vars, pointKeys, pointValues, tspan] = ringModulator
    syms C Cp Lh Ls1 Ls2 Ls3 gam R Rp Rg1 Rg2 Rg3 Ri Rc del
    params = [C Cp Lh Ls1 Ls2 Ls3 gam R Rp Rg1 Rg2 Rg3 Ri Rc del];
    [eqs, vars, pointKeys, pointValues] = problem.ringModulator;
    eqs = subs(eqs, params, substitutePoint(params, pointKeys, pointValues));
    tspan = [0, 1e-3];
end
