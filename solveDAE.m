function solveDAE(eqs, vars, n, tspan, x0, xp0)

syms t
%vars = vars(t);

F = daeFunction(eqs, vars);
[x0, xp0] = decic(F, 0, x0, [], xp0, []);
[tSol, xSol] = ode15i(F, tspan, x0, xp0);

for k = 1:n
    S{k} = char(vars(k));
end

plot(tSol, xSol(:, 1:n));
legend(S, 'Location', 'Best')
grid on
