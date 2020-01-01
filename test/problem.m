classdef problem
    methods (Static)
        function [eqs, vars, pointKeys, pointValues] = pendulum
            syms y(t) z(t) T(t)
            syms g m L
            
            eqs = [
                m*diff(y(t), 2) == y(t)*T(t)/L
                m*diff(z(t), 2) == z(t)*T(t)/L - m*g
                y(t)^2 + z(t)^2 == L^2
            ];
            vars = [y, z, T];
            
            pointKeys = [g m L y z T diff(y) diff(z) diff(T) diff(y, 2) diff(z, 2)];
            pointValues = [9.8 1 1 sin(pi/6) -cos(pi/6) -8.48704895708750 0 0 0 -4.243524478543749 -2.45];
        end
        
        function [eqs, vars, pointKeys, pointValues] = modifiedPendulum
            syms x1(t) x2(t) x3(t) x4(t) x5(t)
            syms g positive
            
            eqs = [
                diff(x4(t)) - x1(t)*x2(t)*cos(x3(t))
                diff(x5(t)) - x2(t)^2*cos(x3(t))*sin(x3(t)) + g
                x1(t)^2 + x2(t)^2*sin(x3(t))^2 - 1
                tanh(diff(x1(t)) - x4(t))
                diff(x2(t))*sin(x3(t)) + x2(t)*diff(x3(t))*cos(x3(t)) - x5(t)
            ];
            vars = [x1 x2 x3 x4 x5];
            
            pointKeys = [g x1 x2 x3 x4 x5 diff(x1) diff(x2) diff(x3) diff(x4) diff(x5)];
            pointValues = [9.8 0.5 8.5311195044981 -3.03990380183 0 0 0 0 0 -4.2435244785437 -2.45];
        end
        
        function [eqs, vars, pointKeys, pointValues] = roboticArm
            syms x1(t) x2(t) x3(t) x4(t) x5(t)
            p1 = symfun(cos(1-exp(t)) + cos(1-t), t);
            p2 = symfun(sin(1-exp(t)) + sin(1-t), t);
            a = @(y) 2 / (2-cos(y)^2);
            b = @(y) cos(y) / (2-cos(y)^2);
            c = @(y) sin(y) / (2-cos(y)^2);
            d = @(y) sin(y)*cos(y) / (2-cos(y)^2);
            
            eqs = [
                diff(x1(t), 2) - ( 2*c(x3(t))*(diff(x1(t))+diff(x3(t)))^2 + diff(x1(t))^2*d(x3(t)) + (2*x3(t)-x2(t))*(a(x3(t))+2*b(x3(t))) + a(x3(t))*(x4(t)-x5(t)))
                diff(x2(t), 2) - (-2*c(x3(t))*(diff(x1(t))+diff(x3(t)))^2 - diff(x1(t))^2*d(x3(t)) + (2*x3(t)-x2(t))*(1-3*a(x3(t))-2*b(x3(t))) - a(x3(t))*x4(t) + (a(x3(t))+1)*x5(t))
                diff(x3(t), 2) - (-2*c(x3(t))*(diff(x1(t))+diff(x3(t)))^2 - diff(x1(t))^2*d(x3(t)) + (2*x3(t)-x2(t))*(a(x3(t))-9*b(x3(t))) - 2*diff(x1(t))^2*c(x3(t)) - d(x3(t))*(diff(x1(t))+diff(x3(t)))^2 - (a(x3(t))+b(x3(t)))*(x4(t)-x5(t)))
                cos(x1(t)) + cos(x1(t)+x3(t)) - p1(t)
                sin(x1(t)) + sin(x1(t)+x3(t)) - p2(t)
            ];
            vars = [x1 x2 x3 x4 x5];
            
            pointKeys = [t x1 x2 x3 x4 x5 diff(x1) diff(x2) diff(x3) diff(x4) diff(x5) diff(x1, 2) diff(x2, 2) diff(x3, 2)];
            pointValues = [0 0 0.9537503511807 1 -4.2781254864526 -0.7437526892114 -1 -2.5319168790105 0 10.7800085515996 15.9886113811556 -1 -1.147631091390737 1];
        end
        
        function [eqs, vars, pointKeys, pointValues] = transistorAmplifier
            syms x1(t) x2(t) x3(t) x4(t) x5(t) x6(t) x7(t) x8(t)
            syms C1 C2 C3 C4 C5 R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 alph bet Ub UF positive
            Ue = symfun(0.1*sin(200*pi*t), t);
            g  = @(y) bet*(exp(y/UF) - 1);
            
            eqs = [
                 C1*(diff(x1(t))-diff(x2(t))) + (x1(t)-Ue(t)) / R0
                -C1*(diff(x1(t))-diff(x2(t))) - Ub/R2 + x2(t)*(1/R1+1/R2) - (alph-1)*g(x2(t)-x3(t))
                 C2*diff(x3(t)) - g(x2(t)-x3(t)) + x3(t)/R3
                 C3*(diff(x4(t))-diff(x5(t))) + (x4(t)-Ub)/R4 + alph*g(x2(t)-x3(t))
                -C3*(diff(x4(t))-diff(x5(t))) - Ub/R6 + x5(t)*(1/R5+1/R6) - (alph-1)*g(x5(t)-x6(t))
                 C4*diff(x6(t)) - g(x5(t)-x6(t)) + x6(t)/R7
                 C5*(diff(x7(t))-diff(x8(t))) + (x7(t)-Ub)/R8 + alph*g(x5(t)-x6(t))
                -C5*(diff(x7(t))-diff(x8(t))) + x8(t)/R9
            ];
            vars = [x1 x2 x3 x4 x5 x6 x7 x8];

            pointKeys = [ ...
                t C1 C2 C3 C4 C5 R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 alph bet Ub UF ...
                x1 x2 x3 x4 x5 x6 x7 x8 diff(x1) diff(x2) diff(x3) diff(x4) diff(x5) diff(x6) diff(x7) diff(x8) ...
            ];
            pointValues = [ ...
                0 1e-6 2e-6 3e-6 4e-6 5e-6 1000 9000 9000 9000 9000 9000 9000 9000 9000 9000 0.99 1e-6 6 0.026 ...
                0 3 3 6 3 3 6 0 51.3392765171807 51.3392765171807 -166.666666666667 24.9703285154063 24.9703285154063 83.3333333333333 10.0002764024563 10.0002764024563 ...
            ];
        end
        
        function [eqs, vars, pointKeys, pointValues] = ringModulator
            syms x1(t) x2(t) x3(t) x4(t) x5(t) x6(t) x7(t) x8(t) x9(t) x10(t) x11(t) x12(t) x13(t) x14(t) x15(t)
            syms C Cp Lh Ls1 Ls2 Ls3 gam R Rp Rg1 Rg2 Rg3 Ri Rc del positive
            q = @(y) gam * (exp(del*y) - 1);
            Uin1 = symfun(0.5 * sin(2000*pi*t), t);
            Uin2 = symfun(2 * sin(20000*pi*t), t);
            UD1 =  x3(t) - x5(t) - x7(t) - Uin2(t);
            UD2 = -x4(t) + x6(t) - x7(t) - Uin2(t);
            UD3 =  x4(t) + x5(t) + x7(t) + Uin2(t);
            UD4 = -x3(t) - x6(t) + x7(t) + Uin2(t);

            eqs = [
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
            vars = [x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15];
            
            pointKeys = [ ...
                t C Cp Lh Ls1 Ls2 Ls3 gam R Rp Rg1 Rg2 Rg3 Ri Rc del ...
                x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 ...
                diff(x1) diff(x2) diff(x3) diff(x4) diff(x5) diff(x6) diff(x7) diff(x8) diff(x9) diff(x10) diff(x11) diff(x12) diff(x13) diff(x14) diff(x15)
            ];
            pointValues = [ ...
                0 1.6e-8 1e-8 4.45 0.002 5e-4 5e-4 40.67286402e-9 25000 50 36.3 17.3 17.3 50 600 17.7493332 ...
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
                0 0 6.2831853071796e4 -6.2831853071796e4 -6.2831853071796e4 6.2831853071796e4 0 0 0 0 0 0 0 0 0
            ];
        end
        
        function [eqs, vars] = JACMnonlinear
            syms x1(t) x2(t) x3(t)
            eqs = [
                diff(x1(t)) + x2(t)^2 == sin(t)
                diff(x1(t)) + x1(t) + x3(t) == cos(t)
                diff(x1(t)) + x3(t) == t
            ];
            vars = [x1, x2, x3];
        end
        
        function [eqs, vars] = JACMexample1
            syms x1(t) x2(t) x3(t) x4(t) a1 a2 a3 a4 a5 f1(t) f2(t) f3(t) f4(t)
            eqs = [
                diff(x1(t), 2) - diff(x1(t)) + diff(x2(t), 2) - diff(x2(t)) + x4(t) == f1(t)
                                            diff(x1(t), 2) + diff(x2(t), 2) + x3(t) == f2(t)
                                      a1*x2(t) + a2*diff(x3(t), 2) + a3*diff(x4(t)) == f3(t)
                                                          a4*x3(t) + a5*diff(x4(t)) == f4(t)
            ];
            vars = [x1, x2, x3, x4];
        end
        
        function [eqs, vars] = JACMexample2
            syms i1(t) i2(t) i3(t) i4(t) i5(t) v1(t) v2(t) v3(t) v4(t) v5(t) Volt(t) R1 R2 L C
            eqs = [
                -i1(t) - i4(t) + i5(t)
                i2(t) + i3(t) + i4(t) - i5(t)
                v1(t) + v3(t) - v5(t)
                -v1(t) - v2(t) + v4(t)
                v2(t) - v3(t)
                R1*i1(t) - v1(t)
                R2*i2(t) - v2(t)
                L*diff(i3(t)) - v3(t)
                -i4(t) + C*diff(v4(t))
                v5(t) - Volt(t)
            ];
            vars = [i1 i2 i3 i4 i5 v1 v2 v3 v4 v5];
        end
    end
end
