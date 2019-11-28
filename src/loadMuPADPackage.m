function loadMuPADPackage

% LOADMUPADPACKAGE    Load MuPAD Package 'daepp'.
%
%   Load MuPAD package 'daepp' with reload prevension. To force reloading,
%   reset the flag by 'clear loadMuPADPackage' before calling this method.

narginchk(0, 0);
persistent loaded;

if isempty(loaded)
    packagepath = [fileparts(mfilename('fullpath')), filesep];
    packagepath = strrep(packagepath, '\', '\\');
    command = {
        % add packagepath to PACKAGEPATH
        ['if not contains({PACKAGEPATH}, "', packagepath, '") then PACKAGEPATH := "', packagepath, '", PACKAGEPATH; end_if;']
        
        % load package
        'package("daepp", Forced);'
    };
    try
        evalin(symengine, strjoin(command));
    catch ME
        throw(ME);
    end
    loaded = true;
end
