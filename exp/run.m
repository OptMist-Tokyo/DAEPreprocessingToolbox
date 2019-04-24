addpath("../src", "../test");

[eqs, vars, y0est, yp0est, tspan] = modifiedPendulum;
experiment(eqs, vars, y0est, yp0est, tspan, 'substitution');


function [eqs, vars, y0est, yp0est, tspan] = pendulum
    syms g m L;
    [eqs, vars] = problem.pendulum;
    eqs = subs(eqs, [g, m, L], [9.8, 1, 1]);
    y0est = [sin(pi/6), -cos(pi/6), 0, 0, 0, 0, 0];
    yp0est = [0, 0, 0, 0, 0, 0, 0];
    tspan = [0, 0.5];
end


function [eqs, vars, y0est, yp0est, tspan] = modifiedPendulum
    syms g;
    [eqs, vars] = problem.modifiedPendulum;
    eqs = subs(eqs, g, 9.8);
    y0est = [0.5; 8.5311195044981; 3.2432815053528; 0; 0];
    yp0est = [0; 0; 0; -4.2435244785437; -2.45];
    tspan = [0, 5];
end


function [eqs, vars, y0est, yp0est, tspan] = roboticArm
    [eqs, vars] = problem.roboticArm;
    y0est = [0; 0.9537503511807; 1; -4.2781254864526; -0.7437526892114];
    yp0est = [-1; -2.5319168790105; 0; 10.7800085515996; 15.9886113811556];
    y0est = zeros(22, 1);
    yp0est = zeros(22, 1);
    tspan = [0, 1];
end


function [eqs, vars, y0est, yp0est, tspan] = transistorAmplifier
    syms C1 C2 C3 C4 C5 R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 alph bet Ub UF
    params = [C1 C2 C3 C4 C5 R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 alph bet Ub UF];
    vals   = [1e-6 2e-6 3e-6 4e-6 5e-6 1000 9000 9000 9000 9000 9000 9000 9000 9000 9000 0.99 1e-6 6 0.026];
    [eqs, vars] = problem.transistorAmplifier;
    eqs = subs(eqs, params, vals);
    y0est = [0; 3; 3; 6; 3; 3; 6; 0];
    yp0est = [51.3392765171807; 51.3392765171807; -166.666666666667; 24.9703285154063; 24.9703285154063; 83.3333333333333; 10.0002764024563; 10.0002764024563];
    tspan = [0, 0.2];
end


function [eqs, vars, y0est, yp0est, tspan] = ringModulator
    syms C Cp Lh Ls1 Ls2 Ls3 gam R Rp Rg1 Rg2 Rg3 Ri Rc del
    params = [C Cp Lh Ls1 Ls2 Ls3 gam R Rp Rg1 Rg2 Rg3 Ri Rc del];
    vals   = [1.e6-8 1e-8 4.45 0.002 5e-4 5e-4 40.67286402e-9 25000 50 36.3 17.3 17.3 50 600 17.7493332];
    [eqs, vars] = problem.ringModulator;
    eqs = subs(eqs, params, vals);
    y0est = zeros(22, 1);
    yp0est = zeros(22, 1);
    tspan = [0, 1e-3];
end
