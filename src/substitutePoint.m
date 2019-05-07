function value = substitutePoint(f, pointKeys, pointValues)

% substitutePoint    Evaluate f at a point.
%
%   Return the substituted value of f for the point designated by pointKeys and
%   pointValues.

% check input
narginchk(3, 3);
validateattributes(f, {'sym'}, {'2d'}, mfilename, 'f', 1);
point = checkPointInput(pointKeys, pointValues);

% call MuPAD
loadMuPADPackage;
try
    value = double(feval(symengine, 'daepp::substitutePoint', f, point));
catch ME
    throw(ME);
end
