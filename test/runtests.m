import matlab.unittest.TestSuite

% add src to path
addpath(strcat(pwd, '/../src'));

% run tests
suiteClass = TestSuite.fromFolder(pwd);
result = run(suiteClass);
