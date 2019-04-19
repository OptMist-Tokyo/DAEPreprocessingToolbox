function D = systemJacobian(F, x, p, q)

% systemJacobian    Matrix storing partial differentiations
%
%   Return the system Jacobian D whose (i, j)-th entry is the derivative of
%   F(i)^(p(i)) by x(j)^(q(j)). If F is an equation system, the RHS are to be
%   transposed to the LHS.
%
%   See Also: hungarian

% check input
[F, x, ~] = checkInput(F, x);
m = length(F);
n = length(x);
validateattributes(p, {'numeric'}, {'row', 'integer', 'nonnegative'}, mfilename, 'p', 3);
validateattributes(q, {'numeric'}, {'row', 'integer', 'nonnegative'}, mfilename, 'q', 4);
assert(m == length(p), 'Inconsistency between sizes of F and p.');
assert(n == length(q), 'Inconsistency between sizes of x and q.');

D = zeros(m, n, 'sym');

for i = 1:m
    % differentiate
    feasible = find(q >= p(i));
    dx = arrayfun(@(j) diff(x(j), q(j) - p(i)), feasible);
    dFi = diffByFunction(F(i), dx);
    
    % substitte back to D
    for k = 1:length(feasible)
        D(i, feasible(k)) = dFi(k);
    end
end
