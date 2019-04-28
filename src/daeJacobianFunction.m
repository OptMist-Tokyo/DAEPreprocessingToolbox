function jac = daeJacobianFunction(eqs, vars, varargin)

% daeJacobianFunction    Function handle of jacobian matrices
%
%   Get a function handle that returns a cell array of jacobian matrices. The
%   output is intended to be set as 'Jacobian' option of odeset for ode15i.
%   Symbolic parameters in the DAE can be designated in the same way as
%   'daeFunction'. The input DAE should not contain higher order derivatives.

% check input
narginchk(2, Inf);
[eqs, vars, t] = checkDAEInput(eqs, vars);
params = varargin;
cellfun(@(p) validateattributes(p, {'sym'}, {'scalar'}, mfilename), params);

% call MuPAD
loadMuPADPackage;
try
    out = feval(symengine, 'daepp::daeJacobianFunction', eqs, vars, t);
catch ME
    throw(ME);
end

% get return values
J = out(1);
JP = out(2);
Y = out(3).';
YP = out(4).';

% convert to matlab function
varsAndParams = [{t, Y, YP} params];
jac = matlabFunction(J, JP, 'Vars', varsAndParams);
