function D = systemJacobian(F, x, p, q)

% systemJacobian    Matrix storing partial differentiations
%
%   Return the system Jacobian D whose (i, j)-th entry is the derivative of
%   F(i)^(p(i)) by x(j)^(q(j)). If F is an equation system, the RHS are to be
%   transposed to the LHS.
%
%   See Also: hungarian

[F, x, ~] = normalizeDAEInput(F, x, 'Transposition', true);
m = length(F);
n = length(x);
validateattributes(p, {'numeric'}, {'vector', 'integer', 'nonnegative', 'numel', m}, mfilename, 'p', 3);
validateattributes(q, {'numeric'}, {'vector', 'integer', 'nonnegative', 'numel', n}, mfilename, 'q', 4);

D = zeros(m, n, 'sym');

for i = 1:m
    feasible = find(q >= p(i));
    N = length(feasible);
    dx = zeros(1, N, 'sym');
    for k = 1:N
        j = feasible(k);
        dx(k) = diff(x(j), q(j) - p(i));
    end
    
    % call diffByFunction once for performance
    dFi = diffByFunction(F(i), dx);

    for k = 1:N
        D(i, feasible(k)) = dFi(k);
    end
end
