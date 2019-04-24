function newEqs = modifyBySubstitution(eqs, vars, p, q, r, I, J)

% Modify DAE system by the substitution method.

% check inputs
narginchk(7, 7);
[eqs, vars, t] = checkInput(eqs, vars);
validateattributes(p, {'numeric'}, {'vector', 'integer', 'nonnegative'}, mfilename, 'p', 3);
validateattributes(q, {'numeric'}, {'vector', 'integer', 'nonnegative'}, mfilename, 'q', 4);
m = length(eqs);
n = length(vars);
assert(m == length(p), 'Inconsistency between sizes of F and p.');
assert(n == length(q), 'Inconsistency between sizes of x and q.');
validateattributes(r, {'numeric'}, {'scalar', 'integer', 'positive', '<=', m}, mfilename, 'r', 5);
validateattributes(I, {'numeric'}, {'vector', 'integer', 'positive', '<=', m}, mfilename, 'I', 6);
validateattributes(J, {'numeric'}, {'vector', 'integer', 'positive', '<=', n}, mfilename, 'J', 7);
assert(length(I) == length(J), 'Inconsistency between sizes of I and J.');
assert(all(I ~= r) && all(p(r) <= p(I)));

% call MuPAD
loadMuPADPackage;
newEqs = feval(symengine, 'daepp::modifyBySubstitution', eqs, vars, p, q, r, I, J, t).';