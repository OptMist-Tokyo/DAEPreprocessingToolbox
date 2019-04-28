classdef integrationTest < matlab.unittest.TestCase
    methods (Test)
        
        function pendulum(testCase)
            [F, x] = problem.pendulum;
            syms y(t) z(t) T(t)
            syms g m L
            
            S = orderMatrix(F, x);
            testCase.verifyEqual(S, [2 -Inf 0; -Inf 2 0; 0 0 -Inf]);
            
            [~, ~, ~, p, q] = hungarian(S);
            testCase.verifyEqual(p, [0, 0, 2]);
            testCase.verifyEqual(q, [2, 2, 0]);
            
            D = systemJacobian(F, x, p, q);
            testCase.verifyEqual(D, [m 0 -y(t)/L; 0 m -z(t)/L; 2*y(t) 2*z(t) 0]);
            
            [r, I, J] = findEliminatingSubsystemTest.findEliminatingSubsystem(D, p);
            testCase.verifyEqual(r, 0);
            testCase.verifyEqual(I, zeros(1, 0));
            testCase.verifyEqual(J, zeros(1, 0));
        end
        
        function modifiedPendulum(testCase)
            [F, x] = problem.modifiedPendulum;
            syms x1(t) x2(t) x3(t) x4(t) x5(t)
            syms g positive
            
            S = orderMatrix(F, x);
            testCase.verifyEqual(S, [
                   0     0     0     1  -Inf
                -Inf     0     0  -Inf     1
                   0     0     0  -Inf  -Inf
                   1  -Inf  -Inf     0  -Inf
                -Inf     1     1  -Inf     0
            ]);
            
            [~, ~, ~, p, q] = hungarian(S);
            testCase.verifyEqual(p, [0, 0, 1, 0, 0]);
            testCase.verifyEqual(q, [1, 1, 1, 1, 1]);
            
            D = systemJacobian(F, x, p, q);
            % testCase.verifyEqual(D, [
            %                                       0,                    0,                               0, 1, 0
            %                                       0,                    0,                               0, 0, 1
            %                                 2*x1(t), 2*sin(x3(t))^2*x2(t), 2*cos(x3(t))*sin(x3(t))*x2(t)^2, 0, 0
            %      1 - tanh(x4(t) - diff(x1(t), t))^2,                    0,                               0, 0, 0
            %                                       0,           sin(x3(t)),                cos(x3(t))*x2(t), 0, 0
            % ]);
            
            [r, I, J] = findEliminatingSubsystemTest.findEliminatingSubsystem(D, p);
            testCase.verifyEqual(r, 4);
            testCase.verifyEqual(I, [3, 5]);
            testCase.verifyEqual(J, [1, 2]);
        end
        
        function roboticArm(testCase)
            [F, x] = problem.roboticArm;
            syms x1(t) x2(t) x3(t) x4(t) x5(t)
            
            S = orderMatrix(F, x);
            testCase.verifyEqual(S, [
                2     0     1     0     0;
                1     2     1     0     0;
                1     0     2     0     0;
                0  -Inf     0  -Inf  -Inf;
                0  -Inf     0  -Inf  -Inf
            ]);
            
            [~, ~, ~, p, q] = hungarian(S);
            testCase.verifyEqual(p, [0, 0, 0, 2, 2]);
            testCase.verifyEqual(q, [2, 2, 2, 0, 0]);
            
            D = systemJacobian(F, x, p, q);
            testCase.verifyEqual(D, [
                                                1, 0,                   0,                           2/(cos(x3(t))^2 - 2),                        -2/(cos(x3(t))^2 - 2)
                                                0, 1,                   0,                          -2/(cos(x3(t))^2 - 2),                     2/(cos(x3(t))^2 - 2) - 1
                                                0, 0,                   1, - cos(t)/(cos(t)^2 - 2) - 2/(cos(x3(t))^2 - 2), cos(t)/(cos(t)^2 - 2) + 2/(cos(x3(t))^2 - 2)
                - sin(x1(t)) - sin(x1(t) + x3(t)), 0, -sin(x1(t) + x3(t)),                                              0,                                            0
                  cos(x1(t)) + cos(x1(t) + x3(t)), 0,  cos(x1(t) + x3(t)),                                              0,                                            0
            ]);
            
            [r, I, J] = findEliminatingSubsystemTest.findEliminatingSubsystem(D, p);
            testCase.verifyEqual(r, 1);
            testCase.verifyEqual(I, [3, 4, 5]);
            testCase.verifyEqual(J, [1, 3, 4]);
        end
        
        function transistorAmplifier(testCase)
            [F, x] = problem.transistorAmplifier;
            syms x1(t) x2(t) x3(t) x4(t) x5(t) x6(t) x7(t) x8(t)
            syms C1 C2 C3 C4 C5 R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 alph bet Ub UF positive
            
            S = orderMatrix(F, x);
            testCase.verifyEqual(S, [
                   1     1  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf
                   1     1     0  -Inf  -Inf  -Inf  -Inf  -Inf
                -Inf     0     1  -Inf  -Inf  -Inf  -Inf  -Inf
                -Inf     0     0     1     1  -Inf  -Inf  -Inf
                -Inf  -Inf  -Inf     1     1     0  -Inf  -Inf
                -Inf  -Inf  -Inf  -Inf     0     1  -Inf  -Inf
                -Inf  -Inf  -Inf  -Inf     0     0     1     1
                -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     1     1
            ]);
            
            [~, ~, ~, p, q] = hungarian(S);
            testCase.verifyEqual(p, [0, 0, 0, 0, 0, 0, 0, 0]);
            testCase.verifyEqual(q, [1, 1, 1, 1, 1, 1, 1, 1]);
            
            D = systemJacobian(F, x, p, q);
            testCase.verifyEqual(D, [
                  C1, -C1,  0,   0,   0,  0,   0,   0
                 -C1,  C1,  0,   0,   0,  0,   0,   0
                   0,   0, C2,   0,   0,  0,   0,   0
                   0,   0,  0,  C3, -C3,  0,   0,   0
                   0,   0,  0, -C3,  C3,  0,   0,   0
                   0,   0,  0,   0,   0, C4,   0,   0
                   0,   0,  0,   0,   0,  0,  C5, -C5
                   0,   0,  0,   0,   0,  0, -C5,  C5
            ]);
            
            [r, I, J] = findEliminatingSubsystemTest.findEliminatingSubsystem(D, p);
            testCase.verifyEqual(r, 1);
            testCase.verifyEqual(I, 2);
            testCase.verifyEqual(J, 1);
        end
        
        function ringModulator(testCase)
            [F, x] = problem.ringModulator;
            syms x1(t) x2(t) x3(t) x4(t) x5(t) x6(t) x7(t) x8(t) x9(t) x10(t) x11(t) x12(t) x13(t) x14(t) x15(t)
            syms C Cp Lh Ls1 Ls2 Ls3 gam R Rp Rg1 Rg2 Rg3 Ri Rc del positive
            
            S = orderMatrix(F, x);
            testCase.verifyEqual(S, [
                   1  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     0  -Inf     0     0  -Inf  -Inf     0  -Inf
                -Inf     1  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     0  -Inf  -Inf     0     0  -Inf     0
                -Inf  -Inf     0  -Inf     0     0     0  -Inf  -Inf     0  -Inf  -Inf  -Inf  -Inf  -Inf
                -Inf  -Inf  -Inf     0     0     0     0  -Inf  -Inf  -Inf     0  -Inf  -Inf  -Inf  -Inf
                -Inf  -Inf     0     0     0  -Inf     0  -Inf  -Inf  -Inf  -Inf     0  -Inf  -Inf  -Inf
                -Inf  -Inf     0     0  -Inf     0     0  -Inf  -Inf  -Inf  -Inf  -Inf     0  -Inf  -Inf
                -Inf  -Inf     0     0     0     0     1  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf
                   0  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     1  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf
                -Inf     0  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     1  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf
                   0  -Inf     0  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     1  -Inf  -Inf  -Inf  -Inf  -Inf
                   0  -Inf  -Inf     0  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     1  -Inf  -Inf  -Inf  -Inf
                -Inf     0  -Inf  -Inf     0  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     1  -Inf  -Inf  -Inf
                -Inf     0  -Inf  -Inf  -Inf     0  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     1  -Inf  -Inf
                   0  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     1  -Inf
                -Inf     0  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf  -Inf     1
            ]);
            
            [~, ~, ~, p, q] = hungarian(S);
            testCase.verifyEqual(p, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
            testCase.verifyEqual(q, [1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
            
            D = systemJacobian(F, x, p, q);
            [r, I, J] = findEliminatingSubsystemTest.findEliminatingSubsystem(D, p);
            testCase.verifyEqual(r, 3);
            testCase.verifyEqual(I, [4, 5, 6]);
            testCase.verifyEqual(J, [3, 4, 5]);
        end
    end
end
