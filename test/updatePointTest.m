classdef updatePointTest < matlab.unittest.TestCase
    methods (Static)
        function [newPointKeys, newPointValues] = updatePoint(pointKeys, pointValues, R)
            loadMuPADPackage;
            point = feval(symengine, 'daepp::checkPointInput', pointKeys, pointValues);
            out = feval(symengine, 'daepp::updatePoint', point, R);
            newPointKeys = lhs(out);
            newPointValues = double(rhs(out));
        end
    end
    
    methods (Test)
        function test0(testCase)
            pointKeys = zeros(1, 0, 'sym');
            pointValues = zeros(1, 0);
            R = zeros(1, 0, 'sym');
            [newPointKeys, newPointValues] = updatePointTest.updatePoint(pointKeys, pointValues, R);
            testCase.verifyEqual(newPointKeys, zeros(1, 0, 'sym'));
            testCase.verifyEqual(newPointValues, zeros(1, 0));
        end
        
        function test1(testCase)
            syms y(t) z(t) w(t) x(t)
            pointKeys = [y(t) z(t) diff(y(t)) diff(y(t), 2)];
            pointValues = [1 2 3 4];
            R = [w(t) == y(t), x(t) == diff(y(t))];
            [newPointKeys, newPointValues] = updatePointTest.updatePoint(pointKeys, pointValues, R);
            testCase.verifyEqual(newPointKeys, [y(t) z(t) diff(y(t)), diff(y(t), 2), w(t) diff(w(t)) diff(w(t), 2) x(t) diff(x(t))]);
            testCase.verifyEqual(newPointValues, [1 2 3 4 1 3 4 3 4]);
        end
        
        function test2(testCase)
            syms y(t) z(t) g w x
            pointKeys = [y(t) z(t) diff(y(t)) diff(y(t), 2) g];
            pointValues = [1 2 3 4 5];
            R = [w == y(t), x == diff(y(t))];
            [newPointKeys, newPointValues] = updatePointTest.updatePoint(pointKeys, pointValues, R);
            testCase.verifyEqual(newPointKeys, [y(t) z(t) diff(y(t)), diff(y(t), 2), g, w, x]);
            testCase.verifyEqual(newPointValues, [1 2 3 4 5 1 3]);
        end
    end
end
