function varargout = echelon(A, varargin)

% echelon  Make a symbolic matrix A in the row echelon form.
%
% Transform a symbolic matrix A into a row echelon form R = SAP, where S is a
% matrix with determinant +1 or -1 and P is a permutation. The resulting matrix
% is in the form
%
%   [D *]
%   [O O],
%
% where D is a nonsingular diagonal matrix of size rank A.
%
% echelon(..., 'ReturnPivots', true) additionally returns the set of pivots used
% in the elimination. This means that R is a valid echelon form of A only at
% which all pivots are nonzero.
%
%   Return Values:
%       -       R : row echelon form of A 
%       - colperm : R(:, j) corresponds to A(:, colperm[j])
%       -    rank : rank of A
%       -  pivots : set of pivots (if 'ReturnPivots' is set to true)

validateattributes(A, {'sym'}, {'2d'}, mfilename, 'A');

% parse parameters
parser = inputParser;
addParameter(parser, 'ReturnPivots', false, @(x) validateattributes(x, {'logical'}, {'scalar'}));
parser.parse(varargin{:});
options = parser.Results;

[m, n] = size(A);
rank = 0;
colperm = 1:n;
R = A;
pivots = zeros(1, 0, 'sym');

for b = 1:min(m, n)
    % find a pivot (s, t)
    pivcand = 1:((m-b+1)*(n-b+1));
    
    cont = false;
    for piv = pivcand
        [s, t] = ind2sub([m-b+1, n-b+1], piv);
        s = s + b - 1;
        t = t + b - 1;
        
        [is0, simplified] = isZero(R(s, t));
        R(s, t) = simplified;
        
        if ~is0
            cont = true;
            break;
        end
    end
    
    if ~cont
        break;
    end
    
    % add to pivots
    if options.ReturnPivots
        pivots = [pivots, R(s, t)];
    end
    
    % swap rows and colums so that the (s,t)-th entry comes to (b,b)
    R([b, s], :) = R([s, b], :);
    R(:, [b, t]) = R(:, [t, b]);
    colperm([b, t]) = colperm([t, b]);

    % eliminate
    for i = setdiff(1:m, b)
        R(i, :) = R(i, :) - R(b, :) * R(i, b) / R(b, b);
        R(i, b) = 0;
    end
    
    rank = rank + 1;
end

% set return values
varargout{1} = R;
varargout{2} = colperm;
varargout{3} = rank;
if options.ReturnPivots
    varargout{4} = unique(pivots);
end
