classdef applyPolynomialMatrixTest < matlab.unittest.TestCase
    methods (Static)
        function newEqs = applyPolynomialMatrix(eqs, vars, P)
            loadMuPADPackage;
            newEqs = feval(symengine, 'daepp::applyPolynomialMatrix', eqs, vars, P).';
        end
    end
    
    methods (Test)
        function test0(testCase)
            eqs = zeros(0, 1, 'sym');
            vars = zeros(1, 0, 'sym');
            P = zeros(0, 'sym');
            newEqs = applyPolynomialMatrixTest.applyPolynomialMatrix(eqs, vars, P);
            testCase.verifyEqual(newEqs, eqs);
        end
        
        function test1(testCase)
            syms x(t) s
            eqs = sin(x(t));
            vars = x(t);
            P = 100*s^2;
            newEqs = applyPolynomialMatrixTest.applyPolynomialMatrix(eqs, vars, P);
            expected = 100*cos(x(t))*diff(x(t), t, t) - 100*sin(x(t))*diff(x(t), t)^2;
            testCase.verifyEqual(simplify(newEqs - expected), zeros(1, 1, 'sym'));
        end
        
        function test2(testCase)
            syms x(t) y(t) z(t) w(t) f(t) s
            eqs = [
                diff(x(t)) + diff(y(t)) + y(t)^2 == f(t)
                diff(x(t)) + z(t) + w(t) == f(t)
                diff(x(t)) + z(t)*diff(w(t)) + w(t) == f(t)
            ];
            vars = [x, y, z, w];
            P = [
                1       0 s
                0 2*s^2+1 0
            ];
            newEqs = applyPolynomialMatrixTest.applyPolynomialMatrix(eqs, vars, P);
            expected = [
                y(t)^2 + diff(w(t), t, t)*z(t) + diff(w(t), t) - diff(f(t), t) - f(t) + diff(x(t), t) + diff(y(t), t) + diff(z(t), t)*diff(w(t), t) + diff(x(t), t, t)
                z(t) + w(t) + diff(x(t), t) - f(t) - 2*diff(f(t), t, t) + 2*diff(w(t), t, t) + 2*diff(z(t), t, t) + 2*diff(x(t), t, t, t)
            ];
            testCase.verifyEqual(simplify(newEqs - expected), zeros(2, 1, 'sym'));
        end
    end
end
