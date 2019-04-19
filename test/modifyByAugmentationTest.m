classdef modifyByAugmentationTest < matlab.unittest.TestCase
    methods (Test)
        function test1(testCase)
            syms y(t) z(t)
            F = [
                log(y(t)) == t
                z(t) + y(t) == 0
            ];
            x = [y, z];
            p = [0, 0];
            q = [0, 0];
            r = 2;
            I = 1;
            J = 1;
            
            syms y1(t) constz
            actSolution = modifyByAugmentation(F, x, p, q, r, I, J, 'Constants', 'sym');
            testCase.verifyEqual(actSolution, [
                log(y(t)) - t
                constz + y1(t)
                log(y1(t)) - t
            ]);
        end
        
        function test2(testCase)
            syms y(t) z(t)
            F = [
                log(y(t)) == t
                z(t) + y(t) == 0
            ];
            x = [y, z];
            p = [0, 0];
            q = [0, 0];
            r = 2;
            I = 1;
            J = 1;
            
            syms y1(t)
            actSolution = modifyByAugmentation(F, x, p, q, r, I, J, 'Constants', 'zero');
            testCase.verifyEqual(actSolution, [
                log(y(t)) - t
                y1(t)
                log(y1(t)) - t
            ]);
        end
        
        function test3(testCase)
            syms y(t) z(t) w(t)
            F = [
                y(t) + diff(z(t)) - t^2
                diff(y(t)) - diff(z(t), 2) - 2*t
                diff(y(t)) + diff(z(t), 2) - w(t)
            ];
            x = [y, z, w];
            p = [2, 1, 1];
            q = [2, 3, 1];
            r = 3;
            I = [1, 2];
            J = [1, 2];
            
            syms Dyt(t) Dztt(t) constw
            actSolution = modifyByAugmentation(F, x, p, q, r, I, J, 'Constants', 'sym');
            testCase.verifyEqual(actSolution, [
                y(t) + diff(z(t)) - t^2
                diff(y(t)) - diff(z(t), 2) - 2*t
                Dyt(t) + Dztt(t) - constw
                Dyt(t) + Dztt(t) - 2*t
                Dyt(t) - Dztt(t) - 2*t
            ]);
        end
        
        function test4(testCase)
            syms y(t) z(t) w(t)
            F = [
                y(t) + diff(z(t)) == t^2
                diff(y(t)) - diff(z(t), 2) == 2*t
                diff(y(t)) + diff(z(t), 2) == w(t)
            ];
            x = [y, z, w];
            p = [2, 1, 1];
            q = [2, 3, 1];
            r = 3;
            I = [1, 2];
            J = [1, 2];
            
            syms Dyt(t) Dztt(t)
            actSolution = modifyByAugmentation(F, x, p, q, r, I, J, 'Constants', 'zero');
            testCase.verifyEqual(actSolution, [
                y(t) + diff(z(t)) - t^2
                diff(y(t)) - diff(z(t), 2) - 2*t
                Dyt(t) + Dztt(t) - 0
                Dyt(t) + Dztt(t) - 2*t
                Dyt(t) - Dztt(t) - 2*t
            ]);
        end
    end
end
