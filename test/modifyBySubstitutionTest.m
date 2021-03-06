classdef modifyBySubstitutionTest < matlab.unittest.TestCase
    methods (Static)
    function newEqs = modifyBySubstitution(eqs, vars, p, q, r, I, J, pointKeys, pointValues)
            loadMuPADPackage;
            if nargin == 7
                newEqs = feval(symengine, 'daepp::modifyBySubstitution', eqs, vars, p, q, r, I, J).';
            else
                point = feval(symengine, 'daepp::checkPointInput', pointKeys, pointValues);
                opt = feval(symengine, '_equal', 'Point', point);
                newEqs = feval(symengine, 'daepp::modifyBySubstitution', eqs, vars, p, q, r, I, J, opt).';
            end
        end
    end
    methods (Test)
        function test1(testCase)
            syms y(t) z(t)
            F = [
                log(y(t) + z(t)) == t
                z(t) + y(t) == 0
            ];
            x = [y, z];
            p = [0, 0];
            q = [0, 0];
            r = 2;
            I = 1;
            J = 1;
            actSolution = modifyBySubstitutionTest.modifyBySubstitution(F, x, p, q, r, I, J);
            testCase.verifyEqual(actSolution, [
                log(y(t) + z(t)) - t
                exp(t)
            ]);
        end
        
        function test2(testCase)
            syms y(t) z(t) w(t)
            F = [
                y(t) + diff(z(t)) == t^2 + w(t)
                diff(y(t)) - diff(z(t), 2) == 2*t
                diff(y(t)) + diff(z(t), 2) == diff(w(t))
            ];
            x = [y, z, w];
            p = [2, 1, 1];
            q = [2, 3, 1];
            r = 3;
            I = [1, 2];
            J = [1, 2];
            actSolution = modifyBySubstitutionTest.modifyBySubstitution(F, x, p, q, r, I, J);
            testCase.verifyEqual(actSolution, [
                y(t) + diff(z(t)) - t^2 - w(t)
                diff(y(t)) - diff(z(t), 2) - 2*t
                2*t
            ]);
        end
        
        function test3(testCase)
            syms y(t) z(t) w(t)
            F = [
                y(t)^2 - t
                z(t)^2 - t
                y(t) + z(t)
            ];
            x = [y, z, w];
            p = [0, 0, 0];
            q = [0, 0, 0];
            r = 3;
            I = [1, 2];
            J = [1, 2];
            pointKeys = [t y z w];
            pointValues = [4 2 -2 0];
            actSolution = modifyBySubstitutionTest.modifyBySubstitution(F, x, p, q, r, I, J, pointKeys, pointValues);
            testCase.verifyEqual(actSolution, [
                y(t)^2 - t
                z(t)^2 - t
                0
            ]);
        end
    end
end
