// MuPAD implementation for preprocessDAE.m

daepp::preprocessDAE := proc(eqs, vars)
local options, tVar, point, tTmp, dof, R, constR, S, v, p, q, D, r, II, JJ,
      newR, newConstR, tableR, i;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 2 then
            error("List of equations and list of variables expected.");
        end_if;
    end_if;
    
    // convert to lists
    [eqs, vars] := map([eqs, vars], symobj::tolist);
    
    // get options
    options := prog::getOptions(3, [args()], table(
        Method = "augmentation",
        Constants = "sym",
        MissingConstants = "sym",
        TimeVariable = NIL,
        Point = NIL
    ), TRUE)[1];
    
    tVar := options[TimeVariable];
    point := options[Point];
    
    // check input
    if testargs() then
        [eqs, vars, tTmp] := daepp::checkDAEInput(eqs, vars);
        if not tVar in {NIL, tTmp} then
            error("Inconsistency of time variable.");
        end_if;
        if point <> NIL then
            point := daepp::checkPointInput(point);
        end_if;
    end_if;
    
    // retrieve tVar
    if tVar = NIL then
        tVar := daepp::checkDAEInput(eqs, vars)[3];
    end_if;
    
    dof := infinity;
    [R, constR] := [[], []];
    
    // main loop
    while TRUE do
        // Phase 1: Solve Assignment Problem
        S := daepp::orderMatrix(eqs, vars);
        [v, p, q] := daepp::hungarian(S)[[1, 4, 5]];
        
        if v = -infinity then
            error("There is no perfect matching between equations and variables.");
        end_if;
        if dof <= v then
            error("The optimal value of the assignment problem does not decrease.");
        end_if;
        dof := v;
        
        // Phase 2: Check the Nonsingularity of System Jacobian
        D := daepp::systemJacobian(eqs, vars, p, q, tVar);
        if point = NIL then
            [r, II, JJ] := daepp::findEliminatingSubsystem(D, p);
        else
            V := daepp::substitutePoint(D, point);
            [r, II, JJ] := daepp::findEliminatingSubsystem(D, p, V);
        end_if;
        
        if r = 0 then
            break;
        end_if;
        
        // Phase 3: Modify DAE
        case options[Method]
            of "substitution" do 
                eqs := daepp::modifyBySubstitution(
                    eqs, vars, p, q, r, II, JJ, TimeVariable = tVar, Point = point
                );
                break;
            of "augmentation" do
                [eqs, vars, newR, newConstR] := daepp::modifyByAugmentation(
                    eqs, vars, p, q, r, II, JJ,
                    TimeVariable = tVar,
                    Point = point,
                    Constants = options[Constants],
                    MissingConstants = options[MissingConstants]
                );
                if point <> NIL then
                    point := daepp::updatePoint(point, newR);
                    point := daepp::updatePoint(point, newConstR);
                end_if;
                constR := constR . daepp::updateRelation(newConstR, R);
                R := R . daepp::updateRelation(newR, R);
                break;
            otherwise
                error("Invalid parameter of Method.");
        end_case;
    end_while;
    
    // return
    [eqs, vars, dof, R, constR, point];
end_proc;
