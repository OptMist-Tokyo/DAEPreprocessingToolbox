classdef integrationTest < matlab.unittest.TestCase
    methods (Test)
        function pendulum(testCase)
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
            
            D = systemJacobian(F, x, p, q);
            testCase.verifyEqual(D, [m 0 -y(t)/L; 0 m -z(t)/L; 2*y(t) 2*z(t) 0]);
            
            [r, I, J] = findEliminatingSubsystem(D, p);
            testCase.verifyEqual(r, 0);
            testCase.verifyEqual(I, []);
            testCase.verifyEqual(J, []);
        end
        
        function roboticArm(testCase)
            syms x1(t) x2(t) x3(t) x4(t) x5(t)
            p1 = symfun(cos(1-exp(t)) + cos(1-t), t);
            p2 = symfun(sin(1-exp(t)) + sin(1-t), t);
            a = @(y) 2 / (2-cos(y)^2);
            b = @(y) cos(t) / (2-cos(t)^2);
            c = @(y) sin(t) / (2-cos(t)^2);
            d = @(y) sin(t)*cos(t) / (2-cos(t)^2);
            
            F = [
                diff(x1(t), 2) - ( 2*c(x3(t))*(diff(x1(t))+diff(x3(t)))^2 + diff(x1(t))^2*d(x3(t)) + (2*x3(t)-x2(t))*(a(x3(t))+2*b(x3(t))) + a(x3(t))*(x4(t)-x5(t)))
                diff(x2(t), 2) - (-2*c(x3(t))*(diff(x1(t))+diff(x3(t)))^2 - diff(x1(t))^2*d(x3(t)) + (2*x3(t)-x2(t))*(1-3*a(x3(t))-2*b(x3(t))) - a(x3(t))*x4(t) + (a(x3(t))+1)*x5(t))
                diff(x3(t), 2) - (-2*c(x3(t))*(diff(x1(t))+diff(x3(t)))^2 - diff(x1(t))^2*d(x3(t)) + (2*x3(t)-x2(t))*(a(x3(t))-9*b(x3(t))) - 2*diff(x1(t))^2*c(x3(t)) - d(x3(t))*(diff(x1(t))+diff(x3(t)))^2 - (a(x3(t))+b(x3(t)))*(x4(t)-x5(t)))
                cos(x1(t)) + cos(x1(t)+x3(t)) - p1(t)
                sin(x1(t)) + sin(x1(t)+x3(t)) - p2(t)
            ];
            x = [x1 x2 x3 x4 x5];
            
            S = orderMatrix(F, x);
            testCase.verifyEqual(S, [
                2     0     1     0     0;
                1     2     1     0     0;
                1     0     2     0     0;
                0  -Inf     0  -Inf  -Inf;
                0  -Inf     0  -Inf  -Inf
            ]);
            
            [~, ~, ~, p, q] = hungarian(S);
            testCase.verifyEqual(p, [0; 0; 0; 2; 2]);
            testCase.verifyEqual(q, [2, 2, 2, 0, 0]);
            
            D = systemJacobian(F, x, p, q);
            testCase.verifyEqual(D, [
                                                1, 0,                   0,                           2/(cos(x3(t))^2 - 2),                        -2/(cos(x3(t))^2 - 2)
                                                0, 1,                   0,                          -2/(cos(x3(t))^2 - 2),                     2/(cos(x3(t))^2 - 2) - 1
                                                0, 0,                   1, - cos(t)/(cos(t)^2 - 2) - 2/(cos(x3(t))^2 - 2), cos(t)/(cos(t)^2 - 2) + 2/(cos(x3(t))^2 - 2)
                - sin(x1(t)) - sin(x1(t) + x3(t)), 0, -sin(x1(t) + x3(t)),                                              0,                                            0
                  cos(x1(t)) + cos(x1(t) + x3(t)), 0,  cos(x1(t) + x3(t)),                                              0,                                            0
            ]);
            
            [r, I, J] = findEliminatingSubsystem(D, p);
            testCase.verifyEqual(r, 1);
            testCase.verifyEqual(I, [3; 4; 5]);
            testCase.verifyEqual(J, [1, 3, 4]);
        end
        
        function transistorAmplifier(testCase)
            syms x1(t) x2(t) x3(t) x4(t) x5(t) x6(t) x7(t) x8(t)
            syms C1 C2 C3 C4 C5 R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 alph bet Ub UF positive
            Ue = symfun(0.1*sin(200*pi*t), t);
            g  = @(y) bet*(exp(y/UF) - 1);
            
            F = [
                 C1*(diff(x1(t))-diff(x2(t))) + (x1(t)-Ue(t)) / R0
                -C1*(diff(x1(t))-diff(x2(t))) - Ub/R2 + x2(t)*(1/R1+1/R2) - (alph-1)*g(x2(t)-x3(t))
                 C2*diff(x3(t)) - g(x2(t)-x3(t)) + x3(t)/R3
                 C3*(diff(x4(t))-diff(x5(t))) + (x4(t)-Ub)/R4 + alph*g(x2(t)-x3(t))
                -C3*(diff(x4(t))-diff(x5(t))) - Ub/R6 + x5(t)*(1/R5+1/R6) - (alph-1)*g(x5(t)-x6(t))
                 C4*diff(x6(t)) - g(x5(t)-x6(t)) + x6(t)/R7
                 C5*(diff(x7(t))-diff(x8(t))) + (x7(t)-Ub)/R8 + alph*g(x5(t)-x6(t))
                -C5*(diff(x7(t))-diff(x8(t))) + x8(t)/R9
            ];
            x = [x1 x2 x3 x4 x5 x6 x7 x8];
            
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
            testCase.verifyEqual(p, [0; 0; 0; 0; 0; 0; 0; 0]);
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
            
            [r, I, J] = findEliminatingSubsystem(D, p);
            testCase.verifyEqual(r, 1);
            testCase.verifyEqual(I, 2);
            testCase.verifyEqual(J, 1);
        end
        
        function ringModulator(testCase)
            syms x1(t) x2(t) x3(t) x4(t) x5(t) x6(t) x7(t) x8(t) x9(t) x10(t) x11(t) x12(t) x13(t) x14(t) x15(t)
            syms C Cp Lh Ls1 Ls2 Ls3 gam R Rp Rg1 Rg2 Rg3 Ri Rc del positive
            q = @(y) gam * (exp(del*y) - 1);
            Uin1 = symfun(0.5 * sin(2000*pi*t), t);
            Uin2 = symfun(2 * sin(20000*pi*t), t);
            UD1 =  x3(t) - x5(t) - x7(t) - Uin2(t);
            UD2 = -x4(t) + x6(t) - x7(t) - Uin2(t);
            UD3 =  x4(t) + x5(t) + x7(t) + Uin2(t);
            UD4 = -x3(t) - x6(t) + x7(t) + Uin2(t);

            F = [
                diff(x1(t)) - 1/C *(x8(t) - 0.5*x10(t) + 0.5*x11(t) + x14(t) - x1(t)/R)
                diff(x2(t)) - 1/C *(x9(t) - 0.5*x12(t) + 0.5*x13(t) + x15(t) - x2(t)/R)
                 x10(t) - q(UD1) + q(UD4)
                -x11(t) + q(UD2) - q(UD3)
                 x12(t) + q(UD1) - q(UD3)
                -x13(t) - q(UD2) + q(UD4)
                diff(x7(t)) - 1/Cp*(-x7(t)/Rp + q(UD1) + q(UD2) - q(UD3) - q(UD4))
                diff(x8(t)) + x1(t)/Lh
                diff(x9(t)) + x2(t)/Lh
                diff(x10(t)) - 1/Ls2*( 0.5*x1(t) - x3(t) - Rg2*x10(t))
                diff(x11(t)) - 1/Ls3*(-0.5*x1(t) + x4(t) - Rg3*x11(t))
                diff(x12(t)) - 1/Ls2*( 0.5*x2(t) - x5(t) - Rg2*x12(t))
                diff(x13(t)) - 1/Ls3*(-0.5*x2(t) + x6(t) - Rg3*x13(t))
                diff(x14(t)) - 1/Ls1*(-x1(t) + Uin1(t) - (Ri+Rg1)*x14(t))
                diff(x15(t)) - 1/Ls1*(-x2(t) - (Rc+Rg1)*x15(t))
            ];
            x = [x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15];
            
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
            testCase.verifyEqual(p, [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]);
            testCase.verifyEqual(q, [1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
            
            D = systemJacobian(F, x, p, q);
            [r, I, J] = findEliminatingSubsystem(D, p);
            testCase.verifyEqual(r, 3);
            testCase.verifyEqual(I, [4; 5; 6]);
            testCase.verifyEqual(J, [3, 4, 5]);
        end
    end
end
