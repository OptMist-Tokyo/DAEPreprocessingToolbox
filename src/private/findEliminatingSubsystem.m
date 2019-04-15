function varargout = findEliminatingSubsystem(D, p, varargin)

% findEliminatingSubsystem  Find (r, I, J) satisfying (C1)--(C3) in the paper.
%
% Find a row r, a row subset I not containing r and a column subset J such that
%     - (C1): D(I, J) is nonsingular
%     - (C2): rank D([I r], :) = m
%     - (C3): p(r) ≦ p(i) for all i in I
%
% If 'ReturnPivots' is true, also return the set of used pivots.

validateattributes(D, {'sym'}, {'2d'}, mfilename, 'D');
[m, ~] = size(D);
assert(m == length(p), 'Row size of D and the length of p do not match.')

% parse parameters
parser = inputParser;
addParameter(parser, 'ReturnPivots', false, @(x) validateattributes(x, {'logical'}, {'scalar'}));
parser.parse(varargin{:});
options = parser.Results;

% column operations
[A, rowperm, rank] = echelon(D.');
A = A.';

% the case where D is nonsingular
if rank == m
    varargout{1} = 0;
    varargout{2} = [];
    varargout{3} = [];
    if options.ReturnPivots
        varargout{4} = zeros(1, 0, 'sym');
    end
    return;
end

% find a circuit [I r] (in permuted indices)
circuit = 1:m;
for i = (rank+1):m
    [is0, simplified] = isZero(A(i, :));
    A(i, :) = simplified;
    circuitCand = [find(~is0), i];
    if length(circuitCand) < length(circuit)
        circuit = circuitCand;
    end
end

% separate r from circuit
rcand = circuit(p(rowperm(circuit)) == min(p(rowperm(circuit))));
r = rcand(1);
I = setdiff(circuit, r);

% back to the original indices
r = rowperm(r);
I = sort(rowperm(I)).';

% determine J
if options.ReturnPivots
    [~, rowperm, rank, pivots] = echelon(D(I, :), varargin{:});
else
    [~, rowperm, rank] = echelon(D(I, :));
end

assert(rank == length(I));
J = sort(rowperm(1:rank));

% set return values
varargout{1} = r;
varargout{2} = I;
varargout{3} = J;

if options.ReturnPivots
    varargout{4} = pivots;
end
