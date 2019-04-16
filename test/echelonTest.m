classdef echelonTest < matlab.unittest.TestCase
    methods (Test)
        function test0(testCase)
            [R, colperm, rank] = echelon(zeros(0, 'sym'));
            testCase.verifyEqual(R, zeros(0, 'sym'));
            testCase.verifyEqual(colperm, zeros(1, 0));
            testCase.verifyEqual(rank, 0);
        end
        
        function test1(testCase)
            syms x(t) y(t)
            [R, colperm, rank, pivots] = echelon([0 x(t) 2*x(t); 0 y(t) 2*y(t); t 0 0], 'ReturnPivots', true);
            testCase.verifyEqual(R, [t 0 0; 0 y(t) 2*y(t); 0 0 0]);
            testCase.verifyEqual(colperm, [1, 2, 3]);
            testCase.verifyEqual(rank, 2);
            testCase.verifyEqual(pivots, [t, y(t)]);
        end
        
        function test2(testCase)
            syms x(t) y(t)
            [R, colperm, rank, pivots] = echelon([0 x(t) 2*y(t); 0 x(t) 2*y(t); 0 t 0], 'ReturnPivots', true);
            testCase.verifyEqual(R, [x(t) 0 0; 0 -(2*t*y(t))/x(t) 0; 0 0 0]);
            testCase.verifyEqual(colperm, [2, 3, 1]);
            testCase.verifyEqual(rank, 2);
            testCase.verifyEqual(pivots, [x(t), -(2*t*y(t))/x(t)]);
        end
    end
end
