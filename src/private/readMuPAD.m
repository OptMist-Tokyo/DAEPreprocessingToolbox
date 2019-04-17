function readMuPAD(fname)

% management function for reading MuPAD scripts.

persistent readFiles;
if isempty(readFiles)
    readFiles = containers.Map('KeyType', 'char', 'ValueType', 'logical');
end

if ~readFiles.isKey(fname)
    filepath = [fileparts(mfilename('fullpath')), filesep, '..', filesep, 'mupad', filesep, fname];
    read(symengine, filepath);
    readFiles(fname) = true;
end
