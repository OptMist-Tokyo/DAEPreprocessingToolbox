function logic = isLowIndex(eqs, vars)

% ISLOWINDEX    Check if a DAE is of low index (0 or 1)
%
%   Return true if the DAE is of low differential index (0 or 1). This function
%   can be applied to DAEs with higher order derivatives.
%
%   Example:
%     >> syms x(t) y(t)
%        isLowIndex([x(t)*y(t), diff(x(t))+diff(y(t))], [x, y])
%        returns  true
%
%     >> syms x(t) y(t)
%        isLowIndex([diff(x(t), 2) + y(t), diff(x(t), 2) + x(t) + y(t)], [x, y])
%        returns false
%
%   See also: REDUCEINDEX

% check input
narginchk(2, 2);
[eqs, vars, t] = checkDAEInput(eqs, vars);

% call MuPAD
loadMuPADPackage;
try
    logic = logical(feval(symengine, 'daepp::isLowIndex', eqs, vars, t));
catch ME
    throw(ME);
end
