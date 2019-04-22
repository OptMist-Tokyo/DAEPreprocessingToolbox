classdef modifyByAugmentationTest < matlab.unittest.TestCase
    methods (Test)
        function test1(testCase)
            syms var1(t) var2(t)
            F = [
                log(var1(t)) == t
                var2(t) + var1(t) == 0
            ];
            x = [var1, var2];
            p = [0, 0];
            q = [0, 0];
            r = 2;
            I = 1;
            J = 1;
            
            actSolution = modifyByAugmentation(F, x, p, q, r, I, J, 'Constants', 'sym');
            syms var11(t) constvar2
            testCase.verifyEqual(actSolution, [
                log(var1(t)) - t
                constvar2 + var11(t)
                log(var11(t)) - t
            ]);
        end
        
        function test2(testCase)
            syms var3(t) var4(t)
            F = [
                log(var3(t)) == t
                var4(t) + var3(t) == 0
            ];
            x = [var3, var4];
            p = [0, 0];
            q = [0, 0];
            r = 2;
            I = 1;
            J = 1;
            
            actSolution = modifyByAugmentation(F, x, p, q, r, I, J, 'Constants', 'zero');
            syms var31(t)
            testCase.verifyEqual(actSolution, [
                log(var3(t)) - t
                var31(t)
                log(var31(t)) - t
            ]);
        end
        
        function test3(testCase)
            syms var5(t) var6(t) var7(t)
            F = [
                var5(t) + diff(var6(t)) - t^2
                diff(var5(t)) - diff(var6(t), 2) - 2*t
                diff(var5(t)) + diff(var6(t), 2) - var7(t)
            ];
            x = [var5, var6, var7];
            p = [2, 1, 1];
            q = [2, 3, 1];
            r = 3;
            I = [1, 2];
            J = [1, 2];
            
            actSolution = modifyByAugmentation(F, x, p, q, r, I, J, 'Constants', 'sym');
            syms Dvar5t(t) Dvar6tt(t) constvar7
            testCase.verifyEqual(actSolution, [
                var5(t) + diff(var6(t)) - t^2
                diff(var5(t)) - diff(var6(t), 2) - 2*t
                Dvar5t(t) + Dvar6tt(t) - constvar7
                Dvar5t(t) + Dvar6tt(t) - 2*t
                Dvar5t(t) - Dvar6tt(t) - 2*t
            ]);
        end
        
        function test4(testCase)
            syms var8(t) var9(t) var10(t)
            F = [
                var8(t) + diff(var9(t)) - t^2
                diff(var8(t)) - diff(var9(t), 2) - 2*t
                diff(var8(t)) + diff(var9(t), 2) - var10(t)
            ];
            x = [var8, var9, var10];
            p = [2, 1, 1];
            q = [2, 3, 1];
            r = 3;
            I = [1, 2];
            J = [1, 2];
            
            actSolution = modifyByAugmentation(F, x, p, q, r, I, J, 'Constants', 'zero');
            syms Dvar8t(t) Dvar9tt(t)
            testCase.verifyEqual(actSolution, [
                var8(t) + diff(var9(t)) - t^2
                diff(var8(t)) - diff(var9(t), 2) - 2*t
                Dvar8t(t) + Dvar9tt(t)
                Dvar8t(t) + Dvar9tt(t) - 2*t
                Dvar8t(t) - Dvar9tt(t) - 2*t
            ]);
        end
    end
end
