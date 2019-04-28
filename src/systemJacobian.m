function D = systemJacobian(eqs, vars, p, q)

% systemJacobian    Matrix storing partial differentiations
%
%   Return the system Jacobian D whose (i, j)-th entry is the derivative of
%   eqs(i)^(p(i)) by vars(j)^(q(j)). If F is an equation system, the RHS are
%   moved to the LHS.
%
%   See Also: hungarian

% check input
narginchk(4, 4);
[eqs, vars, t] = checkDAEInput(eqs, vars);
m = length(eqs);
n = length(vars);
validateattributes(p, {'numeric'}, {'vector', 'integer', 'nonnegative'}, mfilename, 'p', 3);
validateattributes(q, {'numeric'}, {'vector', 'integer', 'nonnegative'}, mfilename, 'q', 4);
assert(m == length(p), 'Inconsistency between sizes of eqs and p.');
assert(n == length(q), 'Inconsistency between sizes of vars and q.');

% call MuPAD
loadMuPADPackage;
try
    D = feval(symengine, 'daepp::systemJacobian', eqs, vars, p, q, t);
catch ME
    throw(ME);
end
