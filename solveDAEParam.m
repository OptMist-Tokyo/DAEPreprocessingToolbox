function solveDAEParam(eqs, vars, n, tspan, pk, pv)

xp = setdiff(symvar(eqs), symvar(vars));
xv = num2cell(substitutePoint(xp, pk, pv));
xp = num2cell(xp);
f = daeFunction(eqs, vars, xp{:});
F = @(t, Y, YP) f(t, Y, YP, xv{:});
jac = daeJacobianFunction(eqs, vars, xp{:});
Jac = @(t, Y, YP) jac(t, Y, YP, xv{:});
opt = odeset('Jacobian', Jac);

[x0, xp0] = extractVariableValue(vars, pk, pv, 'MissingVariable', 'zero');
x0 = x0';
xp0 = xp0';
%[x0, xp0] = decic(F, 0, x0, [], xp0, [], opt);

[tSol, xSol] = ode15i(F, tspan, x0, xp0, opt);

for k = 1:n
    S{k} = char(vars(k));
end

plot(tSol, xSol(:, 1:n));
legend(S, 'Location', 'Best')
grid on
