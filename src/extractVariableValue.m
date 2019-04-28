function [y, yp] = extractVariableValue(vars, pointKeys, pointValues)

% extractVariableValue    Extract values of vars and its derivartives from
% point.
%
%   Return [y, yp] such that y[j] and yp[j] are the values of vars[j] and
%   diff(vars[j]) in point designated by pointKeys and pointValues. The return
%   values are supposed to be used as an initial value input for the standard
%   MATLAB DAE functions: decic and ode15i.

% check input
narginchk(3, 3);
[~, vars, t] = checkDAEInput(zeros(0, 1, 'sym'), vars);
point = checkPointInput(pointKeys, pointValues);

% call MuPAD
loadMuPADPackage;
try
    out = feval(symengine, 'daepp::extractVariableValue', vars, point, t);
catch ME
    throw(ME);
end

% get return values
y = double(out(1));
yp = double(out(2));
