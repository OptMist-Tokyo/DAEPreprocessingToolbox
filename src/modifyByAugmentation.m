function [F, x, R, constR] = modifyByAugmentation(F, x, p, q, r, I, J, varargin)

% Modify DAE system by the augmentation method.
%
% Parameters:
%     - Constants   : How represent constants in the new DAE. If Constants is
%                     'sym' (default), the contants are represented by symbolic
%                     objects and the relation to original varaibles is written
%                     in the return value 'constR'. If Constants is 'zero', 0 is
%                     substituted for all constants.
%     - OrderMatrix : The order matrix for this system obtained by 'OrderMatrix'
%                     function. Designating this may decrease the number of
%                     introduced constants.

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

% parse parameters
parser = inputParser;
addParameter(parser, 'Constants', 'sym', @(x) any(validatestring(x, {'zero', 'sym'})));
addParameter(parser, 'OrderMatrix', [], @(x) validateattributes(x, {'numeric'}, {'2d', 'nonnan', 'real'}));
parser.parse(varargin{:});
options = parser.Results;


% make new variables
x_J = arrayfun(@(j) diff(x(j), q(j) - p(r)), J);
y = makeDummyVariable(x_J, F, 'Output', 'symfun');
R = [y.' x_J.'];

% make constants
T = setdiff(1:n, J);
if ~isempty(options.OrderMatrix)
    T = T(arrayfun(@(j) max(options.OrderMatrix([r, I], j).' + p([r, I])) == q(j), T));
else
    T = T(q(T) >= p(r));
end
x_T = arrayfun(@(j) diff(x(j), q(j) - p(r)), T);

if strcmp(options.Constants, 'sym')
    const = makeDummyVariable(x_T, F, 'Prefix', 'const');
    constR = [const.' x_T.'];
else
    const = zeros(1, length(T), 'sym');
end

% augment equations and varaibles
F = [F; arrayfun(@(i) diff(F(i), t, p(i) - p(r)), I).'];
x = [x, y];

% relabel
modI = [r, (m+1):(m+M)];
F(modI) = subs(F(modI), [x_J, x_T], [y, const]);
