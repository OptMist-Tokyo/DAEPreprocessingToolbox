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

%[x1, x2, x3, x4, x5, diff(x1(t)), diff(x2(t)), diff(x3(t)), diff(x4(t)), diff(x5(t))]
%[0.5, 8.5311195044981, 3.2432815053528, 0, 0, 0, 0, 0, -4.2435244785437, -2.45];
