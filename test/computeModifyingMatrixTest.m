classdef computeModifyingMatrixTest < matlab.unittest.TestCase
    methods (Static)
        function Us = computeModifyingMatrix(Q, p, s)
            loadMuPADPackage;
            if nargin == 2
                out = feval(symengine, 'daepp::computeModifyingMatrix', Q, p);
            else
                out = feval(symengine, 'daepp::computeModifyingMatrix', Q, p, s);
            end
            Us = sym(out);
        end
    end
    
    methods (Test)
        function test0(testCase)
            Q = zeros(0);
            p = zeros(1, 0);
            Us = computeModifyingMatrixTest.computeModifyingMatrix(Q, p);
            testCase.verifyEqual(Us, zeros(0, 'sym'));
        end
        
        function test1(testCase)
            Q = zeros(0, 1);
            p = zeros(1, 0);
            Us = computeModifyingMatrixTest.computeModifyingMatrix(Q, p);
            testCase.verifyEqual(Us, zeros(0, 'sym'));
        end
        
        function test2(testCase)
            Q = zeros(1, 0);
            p = 0;
            Us = computeModifyingMatrixTest.computeModifyingMatrix(Q, p);
            testCase.verifyEqual(Us, sym(1));
        end
        
        function test3(testCase)
            Q = 1;
            p = 1;
            Us = computeModifyingMatrixTest.computeModifyingMatrix(Q, p);
            testCase.verifyEqual(Us, sym(1));
        end
        
        function test4(testCase)
            Q = [1 2; 2 4];
            p = [2 1];
            Us = computeModifyingMatrixTest.computeModifyingMatrix(Q, p);
            syms s;
            testCase.verifyEqual(Us, [1 0; -2*s 1]);
        end
        
        function test5(testCase)
            Q = [1 2; 2 4];
            p = [0 10];
            Us = computeModifyingMatrixTest.computeModifyingMatrix(Q, p);
            syms s;
            testCase.verifyEqual(Us, [1 -s^10/2; 0 1]);
        end
        
        function test6(testCase)
            Q = magic(4);
            p = [2 4 3 1];
            Us = computeModifyingMatrixTest.computeModifyingMatrix(Q, p);
            syms s;
            testCase.verifyEqual(Us, [
                 1, (47*s^2)/32, -(83*s)/32, 0
                 0,           1,          0, 0
                 0,    -(9*s)/5,          1, 0
                -s,      -3*s^3,      3*s^2, 1
            ]);
        end
        
        function test7(testCase)
            Q = [1 2; 2 4];
            p = [0 10];
            syms sss;
            Us = computeModifyingMatrixTest.computeModifyingMatrix(Q, p, sss);
            testCase.verifyEqual(Us, [1 -sss^10/2; 0 1]);
        end
    end
end
