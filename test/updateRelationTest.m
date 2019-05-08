classdef updateRelationTest < matlab.unittest.TestCase
    methods (Static)
        function newR = updateRelation(R, refR)
            loadMuPADPackage;
            newR = feval(symengine, 'daepp::updateRelation', R, refR);
        end
    end
    
    methods (Test)
        function test0(testCase)
            newR = updateRelationTest.updateRelation(zeros(1, 0, 'sym'), zeros(1, 0, 'sym'));
            testCase.verifyEqual(newR, zeros(1, 0, 'sym'));
        end
        
        function test1(testCase)
            syms y(t) y2(t) z(t) constz constz2
            R = [
                z(t) == y2(t)
                constz == diff(y2(t));
                constz2 == diff(y2(t), 2);
            ];
            refR = y2(t) == y(t);
            newR = updateRelationTest.updateRelation(R, refR);
            testCase.verifyEqual(newR, [
                z(t) == y(t)
                constz == diff(y(t));
                constz2 == diff(y(t), 2);
            ].');
        end
        
        function test2(testCase)
            syms y(t) y2(t) z(t) constz constz2
            R = [
                z(t) == y2(t)
                constz == diff(y2(t));
                constz2 == diff(y2(t), 2);
            ];
            refR = y2(t) == diff(y(t));
            newR = updateRelationTest.updateRelation(R, refR);
            testCase.verifyEqual(newR, [
                z(t) == diff(y(t))
                constz == diff(y(t), 2);
                constz2 == diff(y(t), 3);
            ].');
        end
    end
end
