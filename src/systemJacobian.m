function D = systemJacobian(F, x, p, q)

% systemJacobian    Matrix storing partial differentiations
%
%   Return the system Jacobian D whose (i, j)-th entry is the derivative of
%   F(i)^(p(i)) by x(j)^(q(j)).
%
%   See Also: hungarian

% normalize and validate inputs
[F, x, ~] = normalizeDAEInput(F, x);
validateattributes(p, {'numeric'}, {'vector', 'integer', 'nonnegative'}, mfilename, 'p', 3);
validateattributes(q, {'numeric'}, {'vector', 'integer', 'nonnegative'}, mfilename, 'q', 4);
m = length(F);
n = length(x);
assert(m == length(p), 'Lengths of F and p do not match.');
assert(n == length(q), 'Lengths of x and q do not match.');

D = zeros(m, n, 'sym');

for i = 1:m
    for j = 1:n
        if q(j) - p(i) >= 0
            D(i, j) = diffByFunction(F(i), diff(x(j), q(j) - p(i)));
        end
    end
end
