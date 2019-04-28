classdef findEliminatingSubsystemTest < matlab.unittest.TestCase
    methods (Static)
        function [r, I, J] = findEliminatingSubsystem(D, p, V)
            loadMuPADPackage;
            if nargin == 2
                out = feval(symengine, 'daepp::findEliminatingSubsystem', D, p);
            else
                out = feval(symengine, 'daepp::findEliminatingSubsystem', D, p, V);
            end
            r = double(out(1));
            I = double(out(2));
            J = double(out(3));
        end
    end
    
    methods (Test)
        function test0(testCase)
            [r, I, J] = findEliminatingSubsystemTest.findEliminatingSubsystem(zeros(0, 'sym'), zeros(1, 0));
            testCase.verifyEqual(r, 0);
            testCase.verifyEqual(I, zeros(1, 0));
            testCase.verifyEqual(J, zeros(1, 0));
        end
        
        function test1(testCase)
            syms y(t) z(t)
            D = [
                  y(t) z(t)    0
                     0 z(t)    t
                t*y(t)    0 -t^3
            ];
            [r, I, J] = findEliminatingSubsystemTest.findEliminatingSubsystem(D, [0; 0; 0]);
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
            [r, I, J] = findEliminatingSubsystemTest.findEliminatingSubsystem(D, [0 1 0 0]);
            testCase.verifyEqual(r, 1);
            testCase.verifyEqual(I, 2);
            testCase.verifyEqual(J, 1);
        end
        
        function test3(testCase)
            syms y(t) z(t)
            D = sym([
                1 0 0 0 0
                0 1 0 0 0
                1 1 0 0 0
                0 0 1 0 0
                0 0 1 0 0
            ]);
            [r, I, J] = findEliminatingSubsystemTest.findEliminatingSubsystem(D, [0 0 0 0 0]);
            testCase.verifyEqual(r, 4);
            testCase.verifyEqual(I, 5);
            testCase.verifyEqual(J, 3);
        end
        
        function test4(testCase)
            syms y(t)
            D = [
                  diff(y(t))   y(t)        0
                           0 2*y(t)  10*y(t)
                2*diff(y(t))      0 -10*y(t)
            ];
            V = [
                2 4   0
                0 8  40
                4 0 -40
            ];
            [r, I, J] = findEliminatingSubsystemTest.findEliminatingSubsystem(D, [0, 0, 0], V);
            testCase.verifyEqual(r, 1);
            testCase.verifyEqual(I, [2, 3]);
            testCase.verifyEqual(J, [2, 3]);
        end
        
        function test5(testCase)
            syms y(t) z(t)
            D = [
                y(t) y(t)
                z(t) z(t)
            ];
            V = [
                2 2
                1 1
            ];
            [r, I, ~] = findEliminatingSubsystemTest.findEliminatingSubsystem(D, [0, 0], V);
            testCase.verifyEqual(r, 2);
            testCase.verifyEqual(I, 1);
        end
        
        function test6(testCase)
            syms y(t) z(t)
            D = [
                y(t) y(t)
                z(t) z(t)
            ];
            V = [
                2 2
                1 1
            ];
            [r, I, ~] = findEliminatingSubsystemTest.findEliminatingSubsystem(D, [0, 1], V);
            testCase.verifyEqual(r, 1);
            testCase.verifyEqual(I, 2);
        end
    end
end
