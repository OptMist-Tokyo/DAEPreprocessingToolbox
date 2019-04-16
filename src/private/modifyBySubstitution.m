function F = modifyBySubstitution(F, x, p, q, r, I, J)

% Modify DAE system by the substitution method.

% check inputs
[F, x, t] = normalizeDAEInput(F, x);
m = length(F);
n = length(x);
validateattributes(p, {'numeric'}, {'vector', 'integer', 'nonnegative', 'numel', m}, mfilename, 'p', 3);
validateattributes(q, {'numeric'}, {'vector', 'integer', 'nonnegative', 'numel', n}, mfilename, 'q', 4);
validateattributes(r, {'numeric'}, {'scalar', 'integer', 'positive', '<=', m}, mfilename, 'r', 5);
validateattributes(I, {'numeric'}, {'vector', 'integer', 'positive', '<=', m}, mfilename, 'I', 6);
M = length(I);
validateattributes(J, {'numeric'}, {'vector', 'integer', 'positive', '<=', n, 'numel', M}, mfilename, 'J', 7);
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
