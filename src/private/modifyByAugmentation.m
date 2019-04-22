function [newEqs, newVars, consts] = modifyByAugmentation(eqs, vars, p, q, r, I, J, varargin)

% Modify DAE system by the augmentation method.
%
% Parameters:
%     - Constants   : How represent constants in the new DAE. If Constants is
%                     'sym' (default), the contants are represented by symbolic
%                     objects and the relation to original varaibles is written
%                     in the return value 'constR'. If Constants is 'zero', 0 is
%                     substituted for all constants.

% check inputs
[eqs, vars, t] = checkInput(eqs, vars);
validateattributes(p, {'numeric'}, {'vector', 'integer', 'nonnegative'}, mfilename, 'p', 3);
validateattributes(q, {'numeric'}, {'vector', 'integer', 'nonnegative'}, mfilename, 'q', 4);
m = length(eqs);
n = length(vars);
assert(m == length(p), 'Inconsistency between sizes of F and p.');
assert(n == length(q), 'Inconsistency between sizes of x and q.');
validateattributes(r, {'numeric'}, {'scalar', 'integer', 'positive', '<=', m}, mfilename, 'r', 5);
validateattributes(I, {'numeric'}, {'vector', 'integer', 'positive', '<=', m}, mfilename, 'I', 6);
validateattributes(J, {'numeric'}, {'vector', 'integer', 'positive', '<=', n}, mfilename, 'J', 7);
assert(length(I) == length(J), 'Inconsistency between sizes of I and J.');
assert(all(I ~= r) && all(p(r) <= p(I)));

% parse parameters
parser = inputParser;
addParameter(parser, 'Constants', 'sym', @(x) any(validatestring(x, {'zero', 'sym'})));
parser.parse(varargin{:});
options = parser.Results;

% pack options into MuPAD table
entries = evalin(symengine, ['Constants = "', options.Constants, '"']);
table = feval(symengine, 'table', entries);

% call MuPAD
loadMuPADPackage;
out = feval(symengine, 'daepp::modifyByAugmentation', eqs, vars, p, q, r, I, J, t, table);

% restore return values
newEqs = out(1).';
newVars = out(2);
if length(out) >= 3
    consts = out(3);
end
