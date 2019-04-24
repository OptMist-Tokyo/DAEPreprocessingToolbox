addpath("../src", "../test");

[eqs, vars, y0est, yp0est, tspan] = pendulum;
experiment(eqs, vars, y0est, yp0est, tspan);

function [eqs, vars, y0est, yp0est, tspan] = pendulum
    syms g m L;
    [eqs, vars] = problem.pendulum;
    eqs = subs(eqs, [g, m, L], [9.8, 1, 1]);
    y0est = [sin(pi/6), -cos(pi/6), 0, 0, 0, 0, 0];
    yp0est = [0, 0, 0, 0, 0, 0, 0];
    tspan = [0, 1];
end

function [eqs, vars, y0est, yp0est, tspan] = modifiedPendulum
    [eqs, vars] = problem.modifiedPendulum;
    eqs = subs(eqs, sym('g'), 9.8);
    y0est = [0.5, 8.5311195044981, 3.2432815053528, 0, 0];
    yp0est = [0, 0, 0, -4.2435244785437, -2.45];
    tspan = [0, 5];
end
