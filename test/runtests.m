import matlab.unittest.TestSuite

% add src to path
testpath = fileparts(mfilename('fullpath'));
srcpath = [testpath, filesep, '..', filesep, 'src', filesep];
addpath(srcpath);

% copy private folder
copyfile([srcpath, filesep, 'private'], [testpath, filesep, 'private']);

% recall loadMuPADPackage
clear loadMuPADPackage
loadMuPADPackage;

% run tests
suiteClass = TestSuite.fromFolder(testpath);
result = run(suiteClass);

% run private tests
rmdir([testpath, filesep, 'private'], 's');
