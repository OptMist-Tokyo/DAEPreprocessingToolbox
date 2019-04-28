function experiment(eqns, vars, pointKeys, pointValues, tspan, method)

nOrigVars = length(eqns);

% Step 1. Preprocess DAEs
fprintf('Preprocess DAEs.\n');
pretty(eqns);
[eqns, vars] = preprocessDAE(eqns, vars, pointKeys, pointValues, 'Method', method, 'Constants', 'zero');
pretty(eqns);

% Step 2. Reduce Differential Order (do nothing for this DAE because there is no higher order derivatives)
fprintf('Reduce Differential Order.\n');
[eqns, vars] = reduceDifferentialOrder(eqns, vars);


% Step 3. Check and Reduce Differential Index
if ~isLowIndexDAE(eqns, vars)
    fprintf('DAE is high-index. Try index reduction.\n') % this will be printed
    %[eqns, vars] = reduceDAEIndex(eqns, vars);
    [eqns, vars] = reduceRedundancies(eqns, vars);
    
    if isLowIndexDAE(eqns, vars)
        fprintf('Index is successfully reduced.\n');
    else
        fprintf('Failed to reduce index.\n');
    end
else
    fprintf('DAE is already low-index.\n')
end

fprintf('DAE = \n');
pretty(eqns)
fprintf('vars = ');
pretty(vars.')


% Step 4. Convert DAE Systems to MATLAB Function Handles
F = daeFunction(eqns, vars);


% Step 5. Find Initial Conditions For Solvers
opt = odeset('jacobian', daeJacobianFunction(eqns, vars));
[y0est, yp0est] = extractVariableValue(vars, pointKeys, pointValues);
[y0, yp0] = decic(F, 0, y0est, [], yp0est, [], opt);


% Step 6. Solve DAEs Using ode15i
[tSol, ySol] = ode15i(F, tspan, y0, yp0, opt);
plot(tSol, ySol(:,1:nOrigVars), '-o')

for k = 1:nOrigVars
    S{k} = char(vars(k));
end

legend(S, 'Location', 'Best')
grid on
