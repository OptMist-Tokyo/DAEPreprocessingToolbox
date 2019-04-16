function [tf, simplified] = isZero(A)

% Determine if each entry of a symbolic matrix A should be treated as zero.
% Also return a simplified formula of A.

validateattributes(A, {'sym'}, {'2d'}, mfilename, 'A');

[m, n] = size(A);
tf = true(m, n);
simplified = zeros(m, n, 'sym');

for i = 1:m
    for j = 1:n
        simplified(i, j) = simplify(A(i, j), 'IgnoreAnalyticConstraints', true, 'Steps', 5);
        tf(i, j) = isAlways(simplified(i, j) == 0, 'Unknown', 'false');
    end
end

