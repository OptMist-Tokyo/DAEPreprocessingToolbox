function experiment(eqns, vars, pointKeys, pointValues, tspan, method)

n = length(eqns);
tSol = [];
ySol = zeros(0, n);

while true
    % Step 1. Preprocess DAEs
    fprintf('Preprocess DAEs.\n');
    [newEqns, newVars] = preprocessDAE(eqns, vars, pointKeys, pointValues, 'Method', method, 'Constants', 'zero');
    
    % Step 2. Check and Reduce Differential Index
    if ~isLowIndex(newEqns, newVars)
        fprintf('DAE is of high index.\n');
        [newEqns, newVars, ~, newPointKeys, newPointValues] = reduceIndex(newEqns, newVars, pointKeys, pointValues);
        
        if isLowIndex(newEqns, newVars)
            fprintf('Index is successfully reduced.\n');
        else
            fprintf('Failed to reduce index.\n');
        end
    else
        newPointKeys = pointKeys;
        newPointValues = pointValues;
        fprintf('DAE is already low index.\n')
    end
    
    % Step 3. Reduce Differential Order
    fprintf('Reduce Differential Order.\n');
    [newEqns, newVars] = reduceDifferentialOrder(newEqns, newVars);
    
    %fprintf('DAE = \n');
    %pretty(newEqns)
    %fprintf('vars = ');
    %pretty(newVars)
    
    % Step 4. Convert DAE Systems to MATLAB Function Handles
    F = daeFunction(newEqns, newVars);
    
    % Step 5. Find Initial Conditions For Solvers
    opt = odeset('Jacobian', daeJacobianFunction(newEqns, newVars));
    [y0est, yp0est] = extractVariableValue(newVars, newPointKeys, newPointValues);
    [y0, yp0] = decic(F, 0, y0est.', [], yp0est.', [], opt);
    
    % Step 6. Solve DAEs Using ode15i
    sol = ode15i(F, tspan, y0, yp0, opt);
    
    if isscalar(sol.x)
        warning('Integration failed.');
        break;
    end
    
    % store result
    tSol = [tSol; sol.x'];
    ySol = [ySol; sol.y(1:n, :)'];
    
    % update tspan
    tspan(1) = sol.x(end);
    if tspan(1) >= tspan(2)
        break;
    end
    
    % update pointValues
    [yval, ypval] = deval(sol, tspan(1));
    for j = 1:length(pointKeys)
        k = find(vars == pointKeys(j), 1);
        if ~isempty(k)
            pointValues(j) = yval(k);
        end
        k = find(diff(vars) == pointKeys(j), 1);
        if ~isempty(k)
            pointValues(j) = ypval(k);
        end
    end
end

% plot
plot(tSol, ySol)

for k = 1:n
    S{k} = char(vars(k));
end

legend(S, 'Location', 'Best')
grid on
