function loadMuPADPackage

% loadMuPADPackage    Load MuPAD Package 'daepp'.
%
%   Load MuPAD package 'daepp' with reload prevension. To force reloading,
%   reset the loaded flag by 'clear loadMuPADPackage' before calling.

narginchk(0, 0);
persistent loaded;

if isempty(loaded)
    packagepath = [fileparts(mfilename('fullpath')), filesep];
    command = {
        % add packagepath to PACKAGEPATH
        ['if not contains({PACKAGEPATH}, "', packagepath, '") then PACKAGEPATH := "', packagepath, '", PACKAGEPATH; end_if;']
        
        % load package
        'package("daepp", Forced);'
    };
    evalin(symengine, strjoin(command));
    loaded = true;
end
