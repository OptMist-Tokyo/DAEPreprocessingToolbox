classdef greedyPivotingTest < matlab.unittest.TestCase
    methods (Static)
        function [p, q, absdet] = greedyPivoting(V)
            out = feval(symengine, 'daepp::greedyPivoting', V);
            p = double(out(1));
            q = double(out(2));
            absdet = double(out(3));
        end
    end
    
    methods (Test)
        function test0(testCase)
            [p, q, absdet] = greedyPivotingTest.greedyPivoting(zeros(0));
            testCase.verifyEqual(p, zeros(1, 0));
            testCase.verifyEqual(q, zeros(1, 0));
            testCase.verifyEqual(absdet, 1);
        end
        
        function test1(testCase)
            [p, q, absdet] = greedyPivotingTest.greedyPivoting(1);
            testCase.verifyEqual(p, 1);
            testCase.verifyEqual(q, 1);
            testCase.verifyEqual(absdet, 1);
        end
        
        function test2(testCase)
            [p, q, absdet] = greedyPivotingTest.greedyPivoting(magic(5));
            testCase.verifyEqual(p, [5, 1, 3, 4, 2]);
            testCase.verifyEqual(q, [3, 2, 4, 5, 1]);
            testCase.verifyEqual(absdet, 5070000);
        end
        
        function test3(testCase)
            [p, q, absdet] = greedyPivotingTest.greedyPivoting([1 2 3 4]);
            testCase.verifyEqual(p, 1);
            testCase.verifyEqual(q, [4, 2, 3, 1]);
            testCase.verifyEqual(absdet, 4);
        end
        
        function test4(testCase)
            [p, q, absdet] = greedyPivotingTest.greedyPivoting([1; 2; 3; 4]);
            testCase.verifyEqual(p, [4, 2, 3, 1]);
            testCase.verifyEqual(q, 1);
            testCase.verifyEqual(absdet, 4);
        end

        function test5(testCase)
            [p, q, absdet] = greedyPivotingTest.greedyPivoting([1 2 3 4; 2 4 6 8]);
            testCase.verifyEqual(p, [2, 1]);
            testCase.verifyEqual(q, [4, 2, 3, 1]);
            testCase.verifyEqual(absdet, 0);
        end
    end
end
