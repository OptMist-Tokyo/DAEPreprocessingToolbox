function simplified = simplifyExpression(A)

% wrapper of simplify

validateattributes(A, {'sym'}, {'2d'}, mfilename, 'A');

[m, n] = size(A);
simplified = zeros(m, n, 'sym');

for i = 1:m
    for j = 1:n
        [num, den] = numden(A(i, j));
        simplified(i, j) = simplify(num, 'IgnoreAnalyticConstraints', true, 'Steps', 5) / den;
    end
end
