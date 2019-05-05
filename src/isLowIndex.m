function logic = isLowIndex(eqs, vars)

% isLowIndex    Check if a DAE is of low index (0 or 1)
%
%    Return true if the DAE is of low differential index (0 or 1). This function
%    can be applied to DAEs with higher order derivatives.

% check input
narginchk(2, 2);
[eqs, vars, t] = checkDAEInput(eqs, vars);

% call MuPAD
loadMuPADPackage;
try
    logic = logical(feval(symengine, 'daepp::isLowIndex', eqs, vars, t));
catch ME
    throw(ME);
end
