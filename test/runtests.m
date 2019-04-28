import matlab.unittest.TestSuite

% add src to path
testpath = fileparts(mfilename('fullpath'));
srcpath = [testpath, filesep, '..', filesep, 'src', filesep];
addpath(srcpath);

% recall loadMuPADPackage
clear loadMuPADPackage
loadMuPADPackage;

% run tests
suiteClass = TestSuite.fromFolder(testpath);
result = run(suiteClass);
