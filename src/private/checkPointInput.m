function point = checkPointInput(pointKeys, pointValues)

% Check point input.

% check input
narginchk(2, 2);
validateattributes(pointKeys, {'sym'}, {'vector'}, mfilename, 'pointKeys', 1);
validateattributes(pointValues, {'double'}, {'vector'}, mfilename, 'pointValues', 2);

% call MuPAD
loadMuPADPackage;
try
    point = feval(symengine, 'daepp::checkPointInput', pointKeys, pointValues);
catch ME
    throw(ME);
end
