function S = orderMatrix(F, x)

% orderMatrix    Matrix storing differential orders of variables in DAE system.
%
%   Return a matrix whose (i, j)-th entry contains the maximum k such that F_i
%   depends on the k-th order derivative of x_j(t).
%   If F_i does not depend on any derivative of x_j(t), the entry is set to
%   -Inf.

[F, x, ~] = normalizeDAEInput(F, x);

m = length(F);
n = length(x);
S = -Inf(m, n);

for i = 1:m
    % find lower order derivatives
    for j = 1:n
        if has(F(i), diff(x(j)))
            S(i, j) = 1;
        elseif has(F(i), x(j))
            S(i, j) = 0;
        end
    end

    % find higher order derivatives
    [~, ~, R] = reduceDifferentialOrder(F(i), x);
    [r, ~] = size(R);
    for k = 1:r
        c = children(R(k, 2));
        j = find(x == c(1));
        S(i, j) = max(S(i, j), length(c));
    end
end
