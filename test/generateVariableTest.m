classdef generateVariableTest < matlab.unittest.TestCase
    methods (Static)
        function newVar = generateVariable(var, order, ngList, varargin)
            loadMuPADPackage;
            
            % parse parameters
            parser = inputParser;
            addParameter(parser, 'TimeVariable', feval(symengine, 'NIL'));
            addParameter(parser, 'Prefix', '');
            addParameter(parser, 'ReturnFunction', true);
            parser.parse(varargin{:});
            options = parser.Results;
            
            % pack options into MuPAD table
            table = feval(symengine, 'table');
            table = feval(symengine, 'daepp::addEntry', table, 'TimeVariable', options.TimeVariable);
            table = feval(symengine, 'daepp::addEntry', table, 'Prefix', ['"', options.Prefix, '"']);
            genfun = feval(symengine, 'is', feval(symengine, '_equal', options.ReturnFunction, true));
            table = feval(symengine, 'daepp::addEntry', table, 'ReturnFunction', genfun);
            
            ngList = feval(symengine, 'indets', ngList, 'All');
            newVar = feval(symengine, 'daepp::generateVariable', var, order, ngList, table);
        end
    end
    
    methods (Test)
        function test1(testCase)
            syms y(t)
            newVar = generateVariableTest.generateVariable(y, 0, []);
            testCase.verifyEqual(newVar, y(t));
        end
        
        function test2(testCase)
            syms y(t)
            newVar = generateVariableTest.generateVariable(y, 0, y);
            testCase.verifyNotEqual(newVar, y(t));
            newName = char(newVar);
            testCase.verifyEqual(newName(1), 'y');
        end
        
        function test3(testCase)
            syms z(s)
            newVar = generateVariableTest.generateVariable(z, 2, [], 'ReturnFunction', false);
            syms Dzss
            testCase.verifyEqual(newVar, Dzss);
        end
        
        function test4(testCase)
            syms y(t) Dytt(t)
            newVar = generateVariableTest.generateVariable(y, 2, Dytt);
            testCase.verifyNotEqual(newVar, Dytt(t));
            newName = char(newVar);
            testCase.verifyEqual(newName(1:4), 'Dytt');
        end
        
        function test5(testCase)
            syms y(t)
            newVar = generateVariableTest.generateVariable(y, 0, [], 'Prefix', 'const');
            syms consty(t)
            testCase.verifyEqual(newVar, consty(t));
        end
        
        function test6(testCase)
            syms t
            nil = feval(symengine, 'NIL');
            newVar = generateVariableTest.generateVariable(nil, 0, [], 'TimeVariable', t, 'Prefix', 'aaa');
            syms aaa(t)
            testCase.verifyEqual(newVar, aaa(t));
        end
        
        function test7(testCase)
            nil = feval(symengine, 'NIL');
            newVar = generateVariableTest.generateVariable(nil, 0, [], 'Prefix', 'aaa', 'ReturnFunction', false);
            syms aaa
            testCase.verifyEqual(newVar, aaa);
        end
    end
end
