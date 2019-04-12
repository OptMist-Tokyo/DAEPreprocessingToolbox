classdef hungarianTest < matlab.unittest.TestCase
    methods (Static)
        function tf = check(M)
            [n, ~] = size(M);
            [v, s, t, p, q] = hungarian(M);
            
            % check if s and t are permutations on {1,....,n}
            if any(sort(s).' ~= 1:n) || any(sort(t) ~= 1:n)
                tf = false;
                return;
            end
            
            % check if s^{-1} = t
            if any(t(s(1:n)) ~= 1:n)
                tf = false;
                return;
            end
            
            % check the feasibility of σ
            for i = 1:n
                if M(i, s(i)) == -Inf
                    tf = false;
                    return;
                end
            end
            
            % check the feasibility of (p, q)
            if any(p < 0) || any(q < 0)
                tf = false;
                return;
            end
            for i = 1:n
                for j = 1:n
                    if q(j) - p(i) < M(i, j)
                        tf = false;
                        return;
                    end
                end
            end
            
            % check the strong duality
            vv = 0;
            for i = 1:n
                vv = vv + M(i, s(i));
            end
            if n >= 1 && (v ~= vv || v ~= sum(q) - sum(p))
                tf = false;
                return;
            end
            
            tf = true;
        end
    end
    
    methods (Test)
        function test0(testCase)
            testCase.verifyThat(hungarianTest.check([]), matlab.unittest.constraints.IsTrue);
        end

        function test1(testCase)
            testCase.verifyThat(hungarianTest.check(1), matlab.unittest.constraints.IsTrue);
        end
        
        function test2(testCase)
            M = [0 1 -Inf -Inf; -Inf 0 1 -Inf; -Inf -Inf 0 1; -Inf -Inf -Inf 0];
            testCase.verifyThat(hungarianTest.check(M), matlab.unittest.constraints.IsTrue);
        end

        function test3(testCase)
            M = zeros(5);
            testCase.verifyThat(hungarianTest.check(M), matlab.unittest.constraints.IsTrue);
        end
        
        function test4(testCase)
            M = -Inf(5);
            for i = 1:5
                M(i, i) = 0;
            end
            testCase.verifyThat(hungarianTest.check(M), matlab.unittest.constraints.IsTrue);
        end
        
        function test5(testCase)
            M = magic(100);
            testCase.verifyThat(hungarianTest.check(M), matlab.unittest.constraints.IsTrue);
        end

        function test6(testCase)
            M = [-Inf 1 -Inf -Inf; -Inf -Inf 1 -Inf; -Inf -Inf -Inf 1; -Inf -Inf -Inf -Inf];
            v = hungarian(M);
            testCase.verifyEqual(v, -Inf);
        end

        function test7(testCase)
            M = [0 -Inf -Inf; 1 -Inf -Inf; 2 3 4];
            v = hungarian(M);
            testCase.verifyEqual(v, -Inf);
        end
    end
end
