classdef generateVariableTest < matlab.unittest.TestCase
    methods (Static)
        function newVar = generateVariable(var, order, ngList, genfun)
            loadMuPADPackage;
            ngList = feval(symengine, 'indets', ngList, 'All');
            table = feval(symengine, 'table');
            genfun = feval(symengine, 'is', feval(symengine, '_equal', genfun, true));
            table = feval(symengine, 'daepp::addEntry', table, 'ReturnFunction', genfun);
            newVar = feval(symengine, 'daepp::generateVariable', var, order, ngList, table);
        end
    end
    
    methods (Test)
        function test1(testCase)
            syms y(t)
            newVar = generateVariableTest.generateVariable(y, 0, [], true);
            testCase.verifyEqual(newVar, y(t));
        end
        
        function test2(testCase)
            syms y(t)
            newVar = generateVariableTest.generateVariable(y, 0, y, true);
            testCase.verifyNotEqual(newVar, y(t));
            newName = char(newVar);
            testCase.verifyEqual(newName(1), 'y');
        end
        
        function test3(testCase)
            syms z(s)
            newVar = generateVariableTest.generateVariable(z, 2, [], false);
            syms Dzss
            testCase.verifyEqual(newVar, Dzss);
        end
        
        function test4(testCase)
            syms y(t) Dytt(t)
            newVar = generateVariableTest.generateVariable(y, 2, Dytt, true);
            testCase.verifyNotEqual(newVar, Dytt(t));
            newName = char(newVar);
            testCase.verifyEqual(newName(1:4), 'Dytt');
        end
    end
end
