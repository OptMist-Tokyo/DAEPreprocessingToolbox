function F = modifyBySubstitution(F, x, p, q, r, I, J)

% Modify DAE system by the substitution method.

% check inputs
[F, x, t] = normalizeDAEInput(F, x);
validateattributes(p, {'numeric'}, {'row', 'integer', 'nonnegative'}, mfilename, 'p', 3);
validateattributes(q, {'numeric'}, {'row', 'integer', 'nonnegative'}, mfilename, 'q', 4);
m = length(F);
n = length(x);
assert(m == length(p), 'Inconsistency between sizes of F and p.');
assert(n == length(q), 'Inconsistency between sizes of x and q.');
validateattributes(r, {'numeric'}, {'scalar', 'integer', 'positive', '<=', m}, mfilename, 'r', 5);
validateattributes(I, {'numeric'}, {'row', 'integer', 'positive', '<=', m}, mfilename, 'I', 6);
validateattributes(J, {'numeric'}, {'row', 'integer', 'positive', '<=', n}, mfilename, 'J', 7);
assert(length(I) == length(J), 'Inconsistency between sizes of I and J.');
assert(all(I ~= r) && all(p(r) <= p(I)));


% prepare equations to be solved
F_I = arrayfun(@(i) diff(F(i), t, p(i) - p(r)), I).';

% prepare varaibles for which wll be solved
x_J = arrayfun(@(j) diff(x(j), q(j) - p(r)), J);
vars = makeDummyVariable(x_J, F_I);
F_I = subs(F_I, x_J, vars);

% solve
out = solve(F_I, vars, 'Real', true, 'ReturnConditions', true, 'IgnoreAnalyticConstraints', true);

% substitute
for i = 1:length(x_J)
    ex = out.(char(vars(i)));
    if isempty(ex)
        error('Cannot solve an equation system.');
    end
    F(r) = subs(F(r), x_J(i), ex);
end

F(r) = simplify(F(r), 'IgnoreAnalyticConstraints', true);
