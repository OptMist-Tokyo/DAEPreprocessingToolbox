function S = orderMatrix(eqs, vars)

%ORDERMATRIX    Matrix storing differential orders of variables in DAE system.
%
%   Return a matrix whose (i, j)th entry contains the maximum k such that
%   eqs(i) depends on the kth order derivative of vars(j). If eqs(i) does not
%   depend on any derivative of vars(j), the entry is set to -Inf.
%
%   Example:
%     >> syms x(t) y(t)
%        orderMatrix([x(t)*y(t), diff(x(t))+diff(y(t))], [x, y])
%        returns  [0, 0; 1, 1]
%
%   See Also: SYSTEMJACOBIAN

% check input
narginchk(2, 2);
[eqs, vars, ~] = checkDAEInput(eqs, vars);

% call MuPAD
loadMuPADPackage;
try
    S = double(feval(symengine, 'daepp::orderMatrix', eqs, vars));
catch ME
    throw(ME);
end
