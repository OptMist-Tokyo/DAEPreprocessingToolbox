function [y, yp] = extractVariableValue(vars, pointKeys, pointValues, varargin)

% extractVariableValue    Extract values of vars and its derivartives from
% point.
%
%   Return [y, yp] such that y[j] and yp[j] are the values of vars[j] and
%   diff(vars[j]) in point designated by pointKeys and pointValues. The return
%   values are supposed to be used as an initial value input for the standard
%   MATLAB DAE functions: decic and ode15i.

% check input
narginchk(3, Inf);
[~, vars, t] = checkDAEInput(zeros(0, 1, 'sym'), vars);
point = checkPointInput(pointKeys, pointValues);

% parse parameters
parser = inputParser;
addParameter(parser, 'MissingVariable', 'warning', @(x) any(validatestring(x, {'zero', 'warning', 'error'})));
parser.parse(varargin{:});
options = parser.Results;

% pack options into MuPAD table
table = feval(symengine, 'table');
table = addEntry(table, 'TimeVariable', t);
table = addEntry(table, 'MissingVariable', options.MissingVariable);

% call MuPAD
loadMuPADPackage;
try
    out = feval(symengine, 'daepp::extractVariableValue', vars, point, table);
catch ME
    throw(ME);
end

% get return values
y = double(out(1));
yp = double(out(2));
