function [newEqs, newVars, t] = checkDAEInput(eqs, vars)

% Check DAE input.

% check input
narginchk(2, 2);
validateattributes(eqs, {'sym'}, {'vector'}, mfilename, 'eqs', 1);
validateattributes(vars, {'sym'}, {'vector'}, mfilename, 'vars', 2);

% call MuPAD
loadMuPADPackage;
try
    out = feval(symengine, 'daepp::checkDAEInput', eqs, vars);
catch ME
    throw(ME);
end

% restore return values
newEqs = out(1).';
newVars = out(2);
t = out(3);
