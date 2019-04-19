classdef findEliminatingSubsystemTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            [r, I, J] = findEliminatingSubsystem(zeros(0, 0, 'sym'), zeros(1, 0));
            testCase.verifyEqual(r, 0);
            testCase.verifyEqual(I, zeros(1, 0));
            testCase.verifyEqual(J, zeros(1, 0));
        end
        
        function test1(testCase)
            syms y(t) z(t)
            [r, I, J] = findEliminatingSubsystem([y(t) z(t) 0; 0 z(t) t; t*y(t) 0 -t^3], [0; 0; 0]);
            testCase.verifyEqual(r, 0);
            testCase.verifyEqual(I, zeros(1, 0));
            testCase.verifyEqual(J, zeros(1, 0));
        end
        
        function test2(testCase)
            syms y(t) z(t)
            D = [
                 y(t)  2*y(t)     0       0
                -y(t) -2*y(t)     0       0
                    0       0  z(t)  2*z(t)
                    0       0 -z(t) -2*z(t)
            ];
            [r, I, J] = findEliminatingSubsystem(D, [0; 1; 0; 0]);
            testCase.verifyEqual(r, 1);
            testCase.verifyEqual(I, 2);
            testCase.verifyEqual(J, 1);
        end
    end
end
