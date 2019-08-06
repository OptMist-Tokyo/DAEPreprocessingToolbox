function D = systemJacobian(eqs, vars)

%SYSTEMJACOBIAN    System Jacobian matrix of DAE system.
%
%   Return the system Jacobian matrix of eqs with respect to the vars. The
%   (i, j)th entry of the resulting matrix is the derivative of eqs(i)^(p(i)) by
%   vars(j)^(q(j)), where p and q are a dual optimal solution of the assignment
%   problem obtained from the order matrix of the DAE system.
%
%   Example:
%     >> syms x(t) y(t)
%        systemJacobian([x(t)*y(t), diff(x(t))+diff(y(t))], [x, y])
%        returns  [y(t), x(t); 1, 1]
%
%   See also: JACOBIAN, ORDERMATRIX.

% check input
narginchk(2, 2);
[eqs, vars, t] = checkDAEInput(eqs, vars);

% compute (p, q)
S = orderMatrix(eqs, vars);
[v, ~, ~, p, q] = hungarian(S);
if v == -Inf
    error('There is no perfect matching between equations and variables.');
end

% call MuPAD
loadMuPADPackage;
try
    D = feval(symengine, 'daepp::systemJacobian', eqs, vars, p, q, t);
catch ME
    throw(ME);
end
