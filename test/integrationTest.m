classdef integrationTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            syms y(t) z(t) T(t);
            syms g m L positive;
            
            F = [
                m*diff(y(t), 2) == y(t)*T(t)/L
                m*diff(z(t), 2) == z(t)*T(t)/L - m*g
                y(t)^2 + z(t)^2 == L^2
            ];
            x = [y, z, T];
            
            S = orderMatrix(F, x);
            testCase.verifyEqual(S, [2 -Inf 0; -Inf 2 0; 0 0 -Inf]);
            
            [~, ~, ~, p, q] = hungarian(S);
            testCase.verifyEqual(p, [0; 0; 2]);
            testCase.verifyEqual(q, [2, 2, 0]);
            
            %D = systemJacobian(F, x, p, q)
        end
    end
end
