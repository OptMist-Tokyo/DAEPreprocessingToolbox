function [optval, s, t, p, q] = hungarian(M)

% hungarian    The hungarian method for assignment problem.
%
%   Compute a maximum assignment for an n x n cost matrix M by the Hungarian
%   method.
%   Also return an optimal solution (p1, ..., pn, q1, ..., qn) of the
%   following dual problem:
%
%       minimize    (q_1 + ... + q_n) - (p_1 + ... + p_n)
%       subject to  q_j - p_i >= M(i, j)                    (1 <= i, j <= n)
%                   q_j and p_i are nonnegative integers    (1 <= i, j <= n)
%
%   Return Values:
%       - optval : the optimal value. If M has no perfect matching, this is
%                  set to -Inf.
%       -      s : the i-th row is assigned to the s(i)-th column
%       -      t : the j-th column is assigned to the t(j)-th row
%                  (t is the inverse of s as a permutation)
%       -      p : optimal dual solution in rows
%       -      q : optimal dual solution in columns
%
%   See Also: orderMatrix, systemJacobian

validateattributes(M, {'double'}, {'2d', 'square', 'nonnan', 'real'}, mfilename, 'M');
assert(isinteger(M) || all(all(M ~= Inf(class(M)))), 'Expected M not to contain Inf.');

readMuPADScript('hungarian.mu');
out = feval(symengine, 'hungarian', M);
optval = double(out(1));
s = double(out(2));
t = double(out(3));
p = double(out(4));
q = double(out(5));
