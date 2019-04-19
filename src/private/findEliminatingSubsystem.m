function [r, I, J] = findEliminatingSubsystem(D, p)

% findEliminatingSubsystem  Find (r, I, J) satisfying (C1)--(C3) in the paper.
%
% Find a row r, a row subset I not containing r and a column subset J such that
%     - (C1): D(I, J) is nonsingular
%     - (C2): rank D([I r], :) = m
%     - (C3): p(r) ≦ p(i) for all i in I

% check input
narginchk(2, 2);
validateattributes(D, {'sym'}, {'2d'}, mfilename, 'D');
[m, ~] = size(D);
validateattributes(p, {'numeric'}, {'vector', 'integer', 'nonnegative', 'numel', m}, mfilename, 'p');

% call MuPAD
loadMuPADPackage;
out = feval(symengine, 'daepp::findEliminatingSubsystem', D, p);

% restore return values
r = double(out(1));
I = double(out(2));
J = double(out(3));
