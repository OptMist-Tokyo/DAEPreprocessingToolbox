classdef substitutePointTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            actSolution = substitutePoint(zeros(0, 'sym'), zeros(1, 0, 'sym'), zeros(1, 0));
            expSolution = zeros(0);
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function test1(testCase)
            syms m g x1(t)
            actSolution = substitutePoint([x1(t) diff(x1); m^2 g], [m, g, x1, diff(x1)], [1, 2, 3, 4]);
            expSolution = [3 4; 1 2];
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
end
