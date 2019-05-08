classdef modifyByAugmentationTest < matlab.unittest.TestCase
    methods (Static)
        function [newEqs, newVars, R, constR] = modifyByAugmentation(eqs, vars, p, q, r, I, J, varargin)
            % retrieve pointKeys and pointValues
            if nargin >= 8 && isa(varargin{1}, 'sym')
                point = feval(symengine, 'daepp::checkPointInput', varargin{1}, varargin{2});
                hasPoint = true;
                startOptArg = 3;
            else
                hasPoint = false;
                startOptArg = 1;
            end
            
            % parse parameters
            parser = inputParser;
            addParameter(parser, 'Constants', 'sym', @(x) any(validatestring(x, {'zero', 'sym', 'point'})));
            addParameter(parser, 'MissingConstants', 'sym', @(x) any(validatestring(x, {'zero', 'sym'})));
            parser.parse(varargin{startOptArg:end});
            options = parser.Results;
            
            % pack options into MuPAD table
            table = feval(symengine, 'table');
            table = feval(symengine, 'daepp::addEntry', table, 'Constants', ['"', options.Constants, '"']);
            table = feval(symengine, 'daepp::addEntry', table, 'MissingConstants', ['"', options.MissingConstants, '"']);
            if hasPoint
                table = feval(symengine, 'daepp::addEntry', table, 'Point', point);
            end
            
            % call MuPAD
            loadMuPADPackage;
            out = feval(symengine, 'daepp::modifyByAugmentation', eqs, vars, p, q, r, I, J, table);
            
            % restore return values
            newEqs = out(1).';
            newVars = out(2).';
            R = out(3);
            constR = out(4);
        end
    end
    
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
            
            [newEqs, newVars, R, constR] = modifyByAugmentationTest.modifyByAugmentation( ...
                F, x, p, q, r, I, J, 'Constants', 'sym');
            syms constvar2
            testCase.verifyEqual(newEqs, [
                log(var1(t)) - t
                constvar2 + newVars(end)
                log(newVars(end)) - t
            ]);
            testCase.verifyEqual(R, newVars(end) == var1(t));
            testCase.verifyEqual(constR, constvar2 == var2(t));
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
            
            [newEqs, newVars, R, constR] = modifyByAugmentationTest.modifyByAugmentation( ...
                F, x, p, q, r, I, J, 'Constants', 'zero');
            testCase.verifyEqual(newEqs, [
                log(var3(t)) - t
                newVars(end)
                log(newVars(end)) - t
            ]);
            testCase.verifyEqual(R, newVars(end) == var3(t));
            testCase.verifyEqual(constR, zeros(1, 0, 'sym'));
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
            
            [newEqs, newVars, R, constR] = modifyByAugmentationTest.modifyByAugmentation( ...
                F, x, p, q, r, I, J, 'Constants', 'sym');
            syms Dvar5t(t) Dvar6tt(t) constvar7
            testCase.verifyEqual(newEqs, [
                var5(t) + diff(var6(t)) - t^2
                diff(var5(t)) - diff(var6(t), 2) - 2*t
                Dvar5t(t) + Dvar6tt(t) - constvar7
                Dvar5t(t) + Dvar6tt(t) - 2*t
                Dvar5t(t) - Dvar6tt(t) - 2*t
            ]);
            testCase.verifyEqual(newVars, [var5(t); var6(t); var7(t); Dvar5t(t); Dvar6tt(t)]);
            testCase.verifyEqual(R, [Dvar5t(t) == diff(var5(t)), Dvar6tt(t) == diff(var6(t), 2)]);
            testCase.verifyEqual(constR, constvar7 == var7(t));
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
            
            [newEqs, newVars, R, constR] = modifyByAugmentationTest.modifyByAugmentation( ...
                F, x, p, q, r, I, J, 'Constants', 'zero');
            syms Dvar8t(t) Dvar9tt(t)
            testCase.verifyEqual(newEqs, [
                var8(t) + diff(var9(t)) - t^2
                diff(var8(t)) - diff(var9(t), 2) - 2*t
                Dvar8t(t) + Dvar9tt(t)
                Dvar8t(t) + Dvar9tt(t) - 2*t
                Dvar8t(t) - Dvar9tt(t) - 2*t
            ]);
            testCase.verifyEqual(newVars, [var8(t); var9(t); var10(t); Dvar8t(t); Dvar9tt(t)]);
            testCase.verifyEqual(R, [Dvar8t(t) == diff(var8(t)), Dvar9tt(t) == diff(var9(t), 2)]);
            testCase.verifyEqual(constR, zeros(1, 0, 'sym'));
        end
        
        function test5(testCase)
            syms var10(t) var11(t)
            F = [
                log(var10(t)) == t
                var11(t) + var10(t) == 0
            ];
            x = [var10, var11];
            p = [0, 0];
            q = [0, 0];
            r = 2;
            I = 1;
            J = 1;
            pointKeys = [var10, var11];
            pointValues = [20, 0];
            
            [newEqs, newVars, R, constR] = modifyByAugmentationTest.modifyByAugmentation( ...
                F, x, p, q, r, I, J, pointKeys, pointValues, 'Constants', 'point');
            testCase.verifyEqual(newEqs, [
                log(var10(t)) - t
                newVars(end)
                log(newVars(end)) - t
            ]);
            testCase.verifyEqual(R, newVars(end) == var10(t));
            testCase.verifyEqual(constR, zeros(1, 0, 'sym'));
        end
        
        function test6(testCase)
            syms var12(t) var13(t) var14(t)
            F = [
                var12(t) + diff(var13(t)) - t^2
                diff(var12(t)) - diff(var13(t), 2) - 2*t
                diff(var12(t)) + diff(var13(t), 2) - var14(t)
            ];
            x = [var12, var13, var14];
            p = [2, 1, 1];
            q = [2, 3, 1];
            r = 3;
            I = [1, 2];
            J = [1, 2];
            pointKeys = t;
            pointValues = 0;
            
            [newEqs, newVars, R, constR] = modifyByAugmentationTest.modifyByAugmentation( ...
                F, x, p, q, r, I, J, pointKeys, pointValues, 'Constants', 'point', 'MissingConstants', 'sym');
            
            syms Dvar12t(t) Dvar13tt(t) constvar14
            testCase.verifyEqual(newEqs, [
                var12(t) + diff(var13(t)) - t^2
                diff(var12(t)) - diff(var13(t), 2) - 2*t
                Dvar12t(t) + Dvar13tt(t) - constvar14
                Dvar12t(t) + Dvar13tt(t) - 2*t
                Dvar12t(t) - Dvar13tt(t) - 2*t
            ]);
            testCase.verifyEqual(newVars, [var12(t); var13(t); var14(t); Dvar12t(t); Dvar13tt(t)]);
            testCase.verifyEqual(R, [Dvar12t(t) == diff(var12(t)), Dvar13tt(t) == diff(var13(t), 2)]);
            testCase.verifyEqual(constR, constvar14 == var14(t));
        end
        
        function test7(testCase)
            syms var15(t) var16(t) var17(t)
            F = [
                diff(var15(t)) + var16(t) + var17(t)
                diff(var15(t)) + var16(t) + var17(t)
                diff(var15(t)) + var16(t) + var17(t)
            ];
            x = [var15, var16, var17];
            p = [0, 0, 0];
            q = [1, 0, 0];
            r = 2;
            I = 1;
            J = 1;
            pointKeys = var16;
            pointValues = 0;
            
            [newEqs, newVars, R, constR] = modifyByAugmentationTest.modifyByAugmentation( ...
                F, x, p, q, r, I, J, pointKeys, pointValues, 'Constants', 'point', 'MissingConstants', 'sym');
            
            syms Dvar15t(t) constvar17
            testCase.verifyEqual(newEqs, [
                diff(var15(t), t) + var16(t) + var17(t)
                constvar17 + Dvar15t(t)
                diff(var15(t), t) + var16(t) + var17(t)
                constvar17 + Dvar15t(t)
            ]);
            testCase.verifyEqual(newVars, [var15(t); var16(t); var17(t); Dvar15t(t)]);
            testCase.verifyEqual(R, Dvar15t(t) == diff(var15(t)));
            testCase.verifyEqual(constR, constvar17 == var17(t));
        end
        
        function test8(testCase)
            syms var15(t) var16(t) var17(t)
            F = [
                diff(var15(t)) + var16(t) + var17(t)
                diff(var15(t)) + var16(t) + var17(t)
                diff(var15(t)) + var16(t) + var17(t)
            ];
            x = [var15, var16, var17];
            p = [0, 0, 0];
            q = [1, 0, 0];
            r = 2;
            I = 1;
            J = 1;
            pointKeys = var16;
            pointValues = 0;
            
            [newEqs, newVars, R, constR] = modifyByAugmentationTest.modifyByAugmentation( ...
                F, x, p, q, r, I, J, pointKeys, pointValues, 'Constants', 'point', 'MissingConstants', 'zero');
            
            syms Dvar15t(t) 
            testCase.verifyEqual(newEqs, [
                diff(var15(t), t) + var16(t) + var17(t)
                Dvar15t(t)
                diff(var15(t), t) + var16(t) + var17(t)
                Dvar15t(t)
            ]);
            testCase.verifyEqual(newVars, [var15(t); var16(t); var17(t); Dvar15t(t)]);
            testCase.verifyEqual(R, Dvar15t(t) == diff(var15(t)));
            testCase.verifyEqual(constR, zeros(1, 0, 'sym'));
        end
    end
end
