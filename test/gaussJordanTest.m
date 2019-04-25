classdef gaussJordanTest < matlab.unittest.TestCase
    methods (Static)
        function [A, rank, pivcol] = gaussJordan(A, values)
            loadMuPADPackage;
            
            if nargin == 1
                out = feval(symengine, 'daepp::gaussJordan', A);
            else
                out = feval(symengine, 'daepp::gaussJordan', A, values);
            end
            
            A = out(1);
            rank = double(out(2));
            pivcol = double(out(3));
        end
    end
    
    methods (Test)
        function test0(testCase)
            [A, rank, pivcol] = gaussJordanTest.gaussJordan(zeros(0, 'sym'));
            % testCase.verifyEqual(A, zeros(0, 'sym'));
            testCase.verifyEqual(rank, 0);
            testCase.verifyEqual(pivcol, zeros(1, 0));
        end

        function test1(testCase)
            syms y(t) z(t)
            [A, rank, pivcol] = gaussJordanTest.gaussJordan([y(t) z(t); y(t) z(t)]);
            testCase.verifyEqual(A, [1 z(t)/y(t); 0 0]);
            testCase.verifyEqual(rank, 1);
            testCase.verifyEqual(pivcol, 1);
        end
        
        function test2(testCase)
            syms y(t) z(t)
            values = [y(t) == 1, z(t) == exp(2)];
            [A, rank, pivcol] = gaussJordanTest.gaussJordan([y(t) z(t); y(t) z(t)], values);
            testCase.verifyEqual(A, [y(t)/z(t) 1; 0 0]);
            testCase.verifyEqual(rank, 1);
            testCase.verifyEqual(pivcol, 2);
        end
        
        function test3(testCase)
            syms y(t)
            values = [t == 1, diff(y(t)) == 2, y(t) == 4];
            A = [
                         t diff(y(t))     0
                         0       y(t)  y(t)
                diff(y(t))          0 -y(t)
            ];
            [A, rank, pivcol] = gaussJordanTest.gaussJordan(A, values);
            testCase.verifyEqual(A, sym([0 1 0; 0 0 1; 1 0 0]));
            testCase.verifyEqual(rank, 3);
            testCase.verifyEqual(pivcol, [2, 3, 1]);
        end
    end
end
