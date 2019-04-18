function S = orderMatrix(F, x)

% orderMatrix    Matrix storing differential orders of variables in DAE system.
%
%   Return a matrix whose (i, j)-th entry contains the maximum k such that F_i
%   depends on the k-th order derivative of x_j(t). If F_i does not depend on
%   any derivative of x_j(t), the entry is set to -Inf. The output is intended
%   to be passed to the "hungarian" function.
%
%   See Also: hungarian

readMuPADScript('OrderMatrix.mu');
S = double(feval(symengine, 'orderMatrix', F, x));
