function [newEqs, newVars, degreeOfFreedom, R, constR, newPointKeys, newPointValues] = preprocessDAE(eqs, vars, varargin)

% preprocessDAE    Preprocess DAE system for structural analysis.
%
%   Convert DAE system to which structural analysis methods (Mattsson--
%   Soederlind's index-reduction method, Sigma method) fail into an amenable
%   form, using the substitution or the augmentation method.
%   
%   This method returns [newEqs, newVars, value], where
%     - newEqs and newVars are vectors of equations and variables, resp., in the
%       new DAE.
%     - value is the optimal value of the assignment problem. This represents
%       the dimension of the solution manifold.
%   Also returns the vector of constants if 'Constants' is set to 'sym'.
%   
%   Parameters:
%     - Method : 'augmentation' (default) or 'substitution'
%           The method which we use. The substitution method repeatedly solves
%           nonlinear equations. The augmentatioin method enlarges the number of
%           equations and variables, and introduces constants.
%     
%     - Constants : 'zero' (default) or 'sym'
%           Designate how represent constants which will be introduced in the
%           augmentation method. If Constants is 'sym', the contants are
%           represented as symbolic objects and returns a vector of introduced
%           constants as the fourth return value. If Constants is 'zero', 0 will
%           be substituted for all constants. Designating 'zero' would return
%           a simplier DAE but may cause a failure if 0 as the constants is out
%           of the domain of DAEs.
%   
%   Reference:
%     Taihei Oki. Improved structural methods for nonlinear differential-
%     algebraic equations via combinatorial relaxation. In Proceedings of the
%     44th International Symposium on Symbolic and Algebraic Computation
%     (ISSAC '19).

% check input
narginchk(2, Inf);
[eqs, vars, t] = checkDAEInput(eqs, vars);

% retrieve pointKeys and pointValues
if nargin >= 3 && isa(varargin{1}, 'sym')
    assert(nargin >= 4, "Fourth argument 'pointValues' is missing.");
    point = checkPointInput(varargin{1}, varargin{2});
    hasPoint = true;
    startOptArg = 3;
else
    hasPoint = false;
    startOptArg = 1;
end

% parse parameters
parser = inputParser;
addParameter(parser, 'Method', 'substitution', @(x) any(validatestring(x, {'substitution', 'augmentation'})));
addParameter(parser, 'Constants', 'zero', @(x) any(validatestring(x, {'zero', 'sym', 'point'})));
addParameter(parser, 'MissingConstants', 'sym', @(x) any(validatestring(x, {'zero', 'sym'})));
parser.parse(varargin{startOptArg:end});
options = parser.Results;

% pack options into MuPAD table
table = feval(symengine, 'table');
table = addEntry(table, 'TimeVariable', t);
if hasPoint
    table = addEntry(table, 'Point', point);
end
table = addEntry(table, 'Constants', options.Constants);
table = addEntry(table, 'MissingConstants', options.MissingConstants);
table = addEntry(table, 'Method', options.Method);

% call MuPAD
loadMuPADPackage;
try
    out = feval(symengine, 'daepp::preprocessDAE', eqs, vars, table);
catch ME
    throw(ME);
end

% restore return values
newEqs = out(1).';
newVars = out(2).';
degreeOfFreedom = double(out(3));
R = [lhs(out(4)).' rhs(out(4)).'];
constR = [lhs(out(5)).' rhs(out(5)).'];
if hasPoint
    newPointKeys = lhs(out(6));
    newPointValues = double(rhs(out(6)));
end
