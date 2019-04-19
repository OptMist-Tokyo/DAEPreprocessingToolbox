import matlab.unittest.TestSuite

% add src to path
addpath('../src');

% copy private folder
mkdir('private');
copyfile('../src/private', 'private');

% recall loadMuPADPackage
clear loadMuPADPackage
loadMuPADPackage;

% run tests
suiteClass = TestSuite.fromFolder(pwd);
result = run(suiteClass);

% run private tests
rmdir('private', 's');
