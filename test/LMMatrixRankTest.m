classdef LMMatrixRankTest < matlab.unittest.TestCase
    methods (Static)
        function [rk, J] = LMMatrixRank(Q, T)
            % call MuPAD
            loadMuPADPackage;
            try
                out = feval(symengine, 'daepp::LMMatrixRank', Q, T);
            catch ME
                throw(ME);
            end
            
            % restore return values
            rk = double(out(1));
            J = double(out(2));
        end
    end
    
    methods (Test)
        function test0(testCase)
            Q = zeros(0);
            T = zeros(0);
            [rk, J] = LMMatrixRankTest.LMMatrixRank(Q, T);
            testCase.verifyEqual(rk, 0);
            testCase.verifyEqual(J, zeros(1, 0));
        end
        
        function test1(testCase)
            Q = [
                1 1 1 1 0
                0 2 1 1 0
            ];
            T = [
                1 0 0 0 1
                0 1 0 0 1
            ];
            
            [rk, J] = LMMatrixRankTest.LMMatrixRank(Q, T);
            testCase.verifyEqual(rk, 4);
            testCase.verifyEqual(J, [1 2 3 4 5]);
        end
        
        function test2(testCase)
            Q = [
                1 0  1  1
                0 1 -1 -1
            ];
            T = [
                1 0  0  0
                0 1  0  0
            ];
            
            [rk, J] = LMMatrixRankTest.LMMatrixRank(Q, T);
            testCase.verifyEqual(rk, 3);
            testCase.verifyEqual(J, [3 4]);
        end
        
        function test3(testCase)
            Q = [
                1 1 0 0
                1 1 0 0
            ];
            T = [
                0 0 1 1
                0 0 0 1
            ];
            
            [rk, J] = LMMatrixRankTest.LMMatrixRank(Q, T);
            testCase.verifyEqual(rk, 3);
            testCase.verifyEqual(J, [1 2 3 4]);
        end
        
        function test4(testCase)
            Q = [
                1 1
                2 2
                3 3
            ];
            T = zeros(0, 2);
            
            [rk, J] = LMMatrixRankTest.LMMatrixRank(Q, T);
            testCase.verifyEqual(rk, 1);
            testCase.verifyEqual(J, [1 2]);
        end
    end
end
