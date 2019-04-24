addpath("../src", "../test");

[eqs, vars, y0est, yp0est, tspan] = modifiedPendulum;
experiment(eqns, vars, y0est, yp0est, tspan);

function [eqs, vars, y0est, yp0est, tspan] = modifiedPendulum
    [eqs, vars] = problem.modifiedPendulum;
    eqs = subs(eqs, sym('g'), 9.8);
    y0est = [0.5, 8.5311195044981, 3.2432815053528, 0, 0];
    yp0est = [0, 0, 0, -4.2435244785437, -2.45];
    tspan = [0, 5];
end
