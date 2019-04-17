function [tf, simplified] = isZero(A)

% Determine if each entry of a symbolic matrix A should be treated as zero.
% Also return a simplified formula of A.

validateattributes(A, {'sym'}, {'2d'}, mfilename, 'A');

[m, n] = size(A);
tf = true(m, n);
simplified = simplifyExpression(A);

for i = 1:m
    for j = 1:n
        tf(i, j) = isAlways(simplified(i, j) == 0, 'Unknown', 'false');
    end
end
