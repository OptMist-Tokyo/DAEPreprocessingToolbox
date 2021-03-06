classdef gaussJordanTest < matlab.unittest.TestCase
    methods (Static)
        function [A, rank, pivcol] = gaussJordan(A, V)
            loadMuPADPackage;
            if nargin == 1
                out = feval(symengine, 'daepp::gaussJordan', A);
            else
                out = feval(symengine, 'daepp::gaussJordan', A, V);
            end
            if isequal(out(1), sym(0))
                A = zeros(size(A), 'sym');
            else
                A = out(1);
            end
            rank = double(out(2));
            pivcol = double(out(3));
        end
    end
    
    methods (Test)
        function test0(testCase)
            [A, rank, pivcol] = gaussJordanTest.gaussJordan(zeros(0, 'sym'));
            testCase.verifyEqual(A, zeros(0, 'sym'));
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
            A = [y(t) z(t); y(t) z(t)];
            V = [1 2; 1 2];
            [A, rank, pivcol] = gaussJordanTest.gaussJordan(A, V);
            testCase.verifyEqual(A, [y(t)/z(t) 1; 0 0]);
            testCase.verifyEqual(rank, 1);
            testCase.verifyEqual(pivcol, 2);
        end
        
        function test3(testCase)
            syms y(t)
            A = [
                         t diff(y(t))     0
                         0       y(t)  y(t)
                diff(y(t))          0 -y(t)
            ];
            V = [
                1 2  0
                0 4  4
                2 0 -4
            ];
            [A, rank, pivcol] = gaussJordanTest.gaussJordan(A, V);
            testCase.verifyEqual(A, sym([0 1 0; 0 0 1; 1 0 0]));
            testCase.verifyEqual(rank, 3);
            testCase.verifyEqual(pivcol, [2, 3, 1]);
        end
        
        function test4(testCase)
            [A, rank, pivcol] = gaussJordanTest.gaussJordan(zeros(2, 'sym'));
            testCase.verifyEqual(A, zeros(2, 'sym'));
            testCase.verifyEqual(rank, 0);
            testCase.verifyEqual(pivcol, zeros(1, 0));
        end
    end
end
