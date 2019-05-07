function [newEqs, newVars, R, newPointKeys, newPointValues] = reduceIndex(eqs, vars, pointKeys, pointValues)

% reduceIndex    Reduce the differential index of DAEs.
%
%    Reduce the differential index of DAEs by the Mattsson--Soederlind's method.
%    If pointKeys and pointValues are provided, this function chooses pivots
%    far from singular at the provided point.

% check input
narginchk(2, 4);
[eqs, vars, t] = checkDAEInput(eqs, vars);

% retrieve pointKeys and pointValues
if nargin >= 3
    assert(nargin >= 4, "Fourth argument 'pointValues' is missing.");
    point = checkPointInput(pointKeys, pointValues);
    hasPoint = true;
else
    hasPoint = false;
end

% pack options into MuPAD table
table = feval(symengine, 'table');
table = addEntry(table, 'TimeVariable', t);
if hasPoint
    table = addEntry(table, 'Point', point);
end

% call MuPAD
loadMuPADPackage;
try
    out = feval(symengine, 'daepp::reduceIndex', eqs, vars, table);
catch ME
    throw(ME);
end

% get return values
newEqs = out(1).';
newVars = out(2).';
R = out(3);
if R == 0
    R = zeros(0, 2, 'sym');
end
if hasPoint
    newPointKeys = feval(symengine, 'lhs', out(4));
    newPointValues = double(feval(symengine, 'rhs', out(4)));
end
