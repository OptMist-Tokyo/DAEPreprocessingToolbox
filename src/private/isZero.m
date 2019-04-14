function [tf, simplified] = isZero(f)

% Determine if a symbolic expression f should be treated as zero.
% Also return a simplified formula of f.

validateattributes(f, {'sym'}, {'scalar'}, mfilename, 'f');

simplified = simplify(f, 'IgnoreAnalyticConstraints', true, 'Steps', 5);
tf = isAlways(simplified == 0, 'Unknown', 'false');
