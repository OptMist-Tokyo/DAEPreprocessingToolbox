function [newEqs, newVars, t] = checkInput(eqs, vars)

% Check DAE Input.

narginchk(2, 2);
validateattributes(eqs, {'sym'}, {'vector'}, mfilename, 'eqs', 1);
validateattributes(vars, {'sym'}, {'vector'}, mfilename, 'vars', 2);

loadMuPADPackage;
out = feval(symengine, 'daepp::checkInput', eqs, vars);

newEqs = out(1).';
newVars = out(2);
t = out(3);
