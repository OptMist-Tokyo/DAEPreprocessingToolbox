function table = addEntry(table, key, value)

% Add entry "key = value" into MuPAD table object.

% check input
narginchk(3, 3);
validateattributes(table, {'sym'}, {'scalar'}, mfilename, 'table', 1);
validateattributes(key, {'char', 'string'}, {'scalartext'}, mfilename, 'key', 2);

% add double quotation
if isa(value, 'char') || isa(value, 'string')
    value = strcat('"', value, '"');
end

% call MuPAD
loadMuPADPackage;
try
    table = feval(symengine, 'daepp::addEntry', table, key, value);
catch ME
    throw(ME);
end
