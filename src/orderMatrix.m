function S = orderMatrix(eqs, vars)

% orderMatrix    Matrix storing differential orders of variables in DAE system.
%
%   Return a matrix whose (i, j)-th entry contains the maximum k such that
%   eqs(i) depends on the k-th order derivative of vars(j). If eqs(i) does not
%   depend on any derivative of vars(j), the entry is set to -Inf. The output is
%   intended to be passed to the "hungarian" function.
%
%   See Also: hungarian

% check input
narginchk(2, 2);
[eqs, vars, ~] = checkDAEInput(eqs, vars);

% call MuPAD
loadMuPADPackage;
S = double(feval(symengine, 'daepp::orderMatrix', eqs, vars));
