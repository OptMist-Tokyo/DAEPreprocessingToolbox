function [tf, simplified] = isZero(f)

% Determine if a symbolic expression f should be treated as zero.
% Also return a simplified formula of f.

validateattributes(f, {'sym'}, {'2d'}, mfilename, 'f');

[m, n] = size(f);
tf = true(m, n);
simplified = f;

for i = 1:m
    for j = 1:n
        simplified(i, j) = simplify(f(i, j), 'IgnoreAnalyticConstraints', true, 'Steps', 5);
        tf(i, j) = isAlways(simplified(i, j) == 0, 'Unknown', 'false');
    end
end

