function D = systemJacobian(eqs, vars)

% systemJacobian    Matrix storing partial differentiations
%
%   Return the system Jacobian D whose (i, j)-th entry is the derivative of
%   eqs(i)^(p(i)) by vars(j)^(q(j)), where p and q are a dual optimal solution
%   of the assignment problem obtained from the order matrix of DAEs.

% check input
narginchk(2, 2);
[eqs, vars, t] = checkDAEInput(eqs, vars);
m = length(eqs);
n = length(vars);

% compute (p, q)
S = orderMatrix(eqs, vars);
[v, ~, ~, p, q] = hungarian(S);
if v == -Inf
    error('There is no perfect matching between equations and variables.');
end

% call MuPAD
loadMuPADPackage;
try
    D = feval(symengine, 'daepp::systemJacobian', eqs, vars, p, q, t);
catch ME
    throw(ME);
end
