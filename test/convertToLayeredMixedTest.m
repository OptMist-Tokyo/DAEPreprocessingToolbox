classdef convertToLayeredMixedTest < matlab.unittest.TestCase
    methods (Static)
        function [eqs, vars, Q, T, R] = convertToLayeredMixed(eqs, vars)
            loadMuPADPackage;
            out = feval(symengine, 'daepp::convertToLayeredMixed', eqs, vars);
            eqs = out(1).';
            vars = out(2).';
            
            Q = out(3);
            if isequal(Q, sym(0))
                Q = zeros(0, length(vars), 'sym');
            end
            
            T = out(4);
            if isequal(T, sym(0))
                T = zeros(0, length(vars), 'sym');
            end
            
            R = [lhs(out(5)).' rhs(out(5)).'];
        end
    end
    
    methods (Test)
        function test0(testCase)
            eqs = zeros(0, 1, 'sym');
            vars = zeros(0, 1, 'sym');
            [newEqs, newVars, Q, T, R] = convertToLayeredMixedTest.convertToLayeredMixed(eqs, vars);
            testCase.verifyEqual(newEqs, eqs);
            testCase.verifyEqual(newVars, vars);
            testCase.verifyEqual(Q, zeros(0, 'sym'));
            testCase.verifyEqual(T, zeros(0, 'sym'));
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
        end
        
        function test1(testCase)
            syms x(t)
            eqs = zeros(1, 1, 'sym');
            vars = x(t);
            [newEqs, newVars, Q, T, R] = convertToLayeredMixedTest.convertToLayeredMixed(eqs, vars);
            testCase.verifyEqual(newEqs, zeros(0, 1, 'sym'));
            testCase.verifyEqual(newVars, vars);
            testCase.verifyEqual(Q, zeros(0, 1, 'sym'));
            testCase.verifyEqual(T, zeros(0, 1, 'sym'));
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
        end
        
        function test2(testCase)
            syms x(t) y(t) z(t)
            eqs = zeros(0, 1, 'sym');
            vars = [x(t); y(t); z(t)];
            [newEqs, newVars, Q, T, R] = convertToLayeredMixedTest.convertToLayeredMixed(eqs, vars);
            testCase.verifyEqual(newEqs, eqs);
            testCase.verifyEqual(newVars, vars);
            testCase.verifyEqual(Q, zeros(0, 3, 'sym'));
            testCase.verifyEqual(T, zeros(0, 3, 'sym'));
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
        end
        
        function test3(testCase)
            eqs = zeros(3, 1, 'sym');
            vars = zeros(0, 1, 'sym');
            [newEqs, newVars, Q, T, R] = convertToLayeredMixedTest.convertToLayeredMixed(eqs, vars);
            testCase.verifyEqual(newEqs, zeros(0, 1, 'sym'));
            testCase.verifyEqual(newVars, zeros(0, 1, 'sym'));
            testCase.verifyEqual(Q, zeros(0, 'sym'));
            testCase.verifyEqual(T, zeros(0, 'sym'));
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
        end
        
        function test4(testCase)
            syms x(t)
            eqs = x(t);
            vars = x(t);
            [newEqs, newVars, Q, T, R] = convertToLayeredMixedTest.convertToLayeredMixed(eqs, vars);
            testCase.verifyEqual(newEqs, eqs);
            testCase.verifyEqual(newVars, vars);
            testCase.verifyEqual(Q, zeros(0, 1, 'sym'));
            testCase.verifyEqual(T, sym(1));
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
        end
        
        function test5(testCase)
            syms x(t)
            eqs = 300*diff(x(t), 5);
            vars = x(t);
            [newEqs, newVars, Q, T, R] = convertToLayeredMixedTest.convertToLayeredMixed(eqs, vars);
            testCase.verifyEqual(newEqs, eqs);
            testCase.verifyEqual(newVars, vars);
            syms s
            testCase.verifyEqual(Q, zeros(0, 1, 'sym'));
            testCase.verifyEqual(T, s^5);
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
        end
        
        function test6(testCase)
            syms x(t)
            eqs = 300*diff(x(t), 5) + 2*x(t);
            vars = x(t);
            [newEqs, newVars, Q, T, R] = convertToLayeredMixedTest.convertToLayeredMixed(eqs, vars);
            testCase.verifyEqual(newEqs - eqs, zeros('sym'));
            testCase.verifyEqual(newVars, vars);
            syms s
            testCase.verifyEqual(Q, 300*s^5 + 2);
            testCase.verifyEqual(T, zeros(0, 1, 'sym'));
            testCase.verifyEqual(R, zeros(0, 2, 'sym'));
        end
        
        function test7(testCase)
            syms x(t)
            eqs = 300*diff(x(t), 5) + 2*x(t) + sin(diff(x(t)));
            vars = x(t);
            [newEqs, newVars, Q, T, R] = convertToLayeredMixedTest.convertToLayeredMixed(eqs, vars);
            
            syms aux(t) s
            testCase.verifyEqual(newEqs - [
                -aux(t) + 2*x(t) + 300*diff(x(t), 5)
                sin(diff(x(t))) + aux(t)
            ], zeros(2, 1, 'sym'));
            testCase.verifyEqual(newVars, [x(t); aux(t)]);
            testCase.verifyEqual(Q, [300*s^5 + 2, -1]);
            testCase.verifyEqual(T, [s, 1]);
            testCase.verifyEqual(R - [aux(t), 2*x(t) + 300*diff(x(t), 5)], zeros(1, 2, 'sym'));
        end
        
        function test8(testCase)
            syms x(t) y(t) z(t) w(t) f(t)
            eqs = [
                diff(x(t)) + diff(y(t)) + y(t)^2 == f(t)
                diff(x(t)) + x(t)*z(t) == f(t)
                diff(x(t)) + z(t) + w(t) == f(t)
                diff(x(t)) + z(t)*diff(w(t)) + w(t) == f(t)
            ];
            vars = [x(t); y(t); z(t); w(t)];
            [newEqs, newVars, Q, T, R] = convertToLayeredMixedTest.convertToLayeredMixed(eqs, vars);
            
            syms aux1(t) aux2(t) s
            testCase.verifyEqual(newEqs - [
                diff(x(t), t) - aux1(t) + diff(y(t), t)
                     w(t) - f(t) + z(t) + diff(x(t), t)
                         diff(x(t), t) - aux2(t) + w(t)
                                y(t)^2 + aux1(t) - f(t)
                       x(t)*z(t) - f(t) + diff(x(t), t)
                    z(t)*diff(w(t), t) + aux2(t) - f(t)
            ], zeros(6, 1, 'sym'));
            testCase.verifyEqual(newVars, [x(t); y(t); z(t); w(t); aux1(t); aux2(t)]);
            testCase.verifyEqual(Q, [
                s, s, 0, 0, -1,  0
                s, 0, 1, 1,  0,  0
                s, 0, 0, 1,  0, -1
            ]);
            testCase.verifyEqual(T, [
                0, 1, 0, 0, 1, 0
                s, 0, 1, 0, 0, 0
                0, 0, 1, s, 0, 1
            ]);
            testCase.verifyEqual(R, [
                aux1(t), diff(x(t), t) + diff(y(t), t)
                aux2(t), diff(x(t), t) + w(t)
            ]);
        end
    end
end
