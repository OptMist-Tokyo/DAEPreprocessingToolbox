function experiment(prob, method)

switch prob
case 'modpend'
    [eqns, vars, pointKeys, pointValues, tspan, referenceSolution] = problem.modifiedPendulum;
case 'transamp'
    [eqns, vars, pointKeys, pointValues, tspan, referenceSolution] = problem.transistorAmplifier;
end

tspan = [tspan(1) (tspan(1)+tspan(2))/2 tspan(2)];
n = length(eqns);

% Step 1. Preprocess DAEs
fprintf('Preprocess DAEs.\n');
if ~strcmp(method, 'none')
    [newEqns, newVars, ~, ~, ~, newPointKeys, newPointValues] ...
        = preprocessDAE(eqns, vars, pointKeys, pointValues, 'Method', method, 'Constants', 'sym');
else
    newEqns = eqns;
    newVars = vars;
    newPointKeys = pointKeys;
    newPointValues = pointValues;
end

% Step 2. Check and Reduce Differential Index
if ~isLowIndex(newEqns, newVars)
    fprintf('DAE is of high index.\n');
    [newEqns, newVars, ~, newPointKeys, newPointValues] = reduceIndex(newEqns, newVars, newPointKeys, newPointValues);

    if isLowIndex(newEqns, newVars)
        fprintf('Index is successfully reduced.\n');
    else
        fprintf('Failed to reduce index.\n');
    end
else
    fprintf('DAE is already low index.\n')
end

% Step 3. Reduce Differential Order
fprintf('Reduce Differential Order.\n');
[newEqns, newVars] = reduceDifferentialOrder(newEqns, newVars);

% Step 4. Convert DAE Systems to MATLAB Function Handles
pDAEs = symvar(newEqns);
pDAEvars = symvar(newVars);
extraParams = setdiff(pDAEs, pDAEvars);
extraParamValues = num2cell(substitutePoint(extraParams, newPointKeys, newPointValues));
extraParams = num2cell(extraParams);
f = daeFunction(newEqns, newVars, extraParams{:});
F = @(t, Y, YP) f(t, Y, YP, extraParamValues{:});

% Step 5. Find Initial Conditions For Solvers
jac = daeJacobianFunction(newEqns, newVars, extraParams{:});
Jac = @(t, Y, YP) jac(t, Y, YP, extraParamValues{:});
[y0est, yp0est] = extractVariableValue(newVars, newPointKeys, newPointValues, 'MissingVariable', 'zero');

title = strcat(prob, '_', method(1:3));
fileID = fopen(sprintf('exp2/data/%s.txt', title), 'w');

fprintf('\nRelTol\tscd\n');
for k = 1:9
    opt = odeset('Jacobian', Jac, 'RelTol', 10^(-k), 'AbsTol', 2*10^(-k-1));
    [y0, yp0] = decic(F, 0, y0est.', [], yp0est.', [], opt);
    sol = ode15i(F, tspan, y0, yp0, opt);
    y_scd = scd(sol.y(1:n, end), referenceSolution);

    fprintf('1e-%02d:\t%f\n', k, y_scd);
    fprintf(fileID, '%d %f\n', k, y_scd);
end

fclose(fileID);
