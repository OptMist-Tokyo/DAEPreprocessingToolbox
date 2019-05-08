/*
  Modify DAE system by the augmentation method.

  Options:
      - Constants   : 'sym' (default) or 'zero'
            Designate how represent constants which will be introduced in the
            augmentation method. If Constants is 'sym', the contants are
            represented by symbolic objects and returns a vector of introduced
            constants as the third return value. If Constants is 'zero', 0 will
            be substituted for all constants. Designating 'zero' would return
            a simplier DAE but may cause a failure if 0 is out of the domain of
            DAEs.
*/

daepp::modifyByAugmentation := proc(eqs, vars, p, q, r, II, JJ)
local options, tVar, point, tTmp, m, n, ngList, vars_J, newVars_J, circuit, S,
      T, vars_T, existingT, missingT, missingConstOpt, constsForExistingT,
      constsForMissingT, genConst, eqs_I, subseq, R, constR;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 7 then
            error("At least seven arguments expected.");
        end_if;
    end_if;
    
    // convert to lists
    [eqs, vars, p, q, II, JJ] := map([eqs, vars, p, q, II, JJ], symobj::tolist);
    
    // get options
    options := prog::getOptions(8, [args()], table(
        TimeVariable = NIL,
        Point = NIL,
        Constants = "sym",
        MissingConstants = "sym"
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
        
        m := nops(eqs);
        if m <> nops(p) then
            error("Inconsistency between sizes of eqs and p.");
        end_if;
        if not _and((testtype(pi, DOM_INT) && pi >= 0) $ pi in p) then
            error("Entries in p are expected to be nonnegative integers.");
        end_if;
        
        n := nops(vars);
        if n <> nops(q) then
            error("Inconsistency between sizes of vars and q.");
        end_if;
        if not _and((testtype(qj, DOM_INT) && qj >= 0) $ qj in q) then
            error("Entries in q are expected to be nonnegative integers.");
        end_if;
        
        if nops(II) <> nops(JJ) then
            error("Inconsistency between sizes of II and JJ.");
        end_if;
        
        if not (testtype(r, DOM_INT) && 1 <= r && r <= m) then
            error("r is invalid index.");
        end_if;
        if not _and((testtype(i, DOM_INT) && 1 <= i && i <= m) $ i in II) then
            error("Invalid indices in II.");
        end_if;
        if contains(II, r) <> 0 then
            error("II sould not contain r.");
        end_if;
        if nops(II) <> nops({op(II)}) then
            error("Duplicated indices in II.");
        end_if;
        if not _and((p[r] <= p[i]) $ i in II) then
            error("p[r] is not minimum in p[i] for i in II.");
        end_if;
        if not _and((testtype(n, DOM_INT) && 1 <= j && j <= n) $ j in JJ) then
            error("Invalid indices in JJ.");
        end_if;
        if nops(JJ) <> nops({op(JJ)}) then
            error("Duplicated indices in JJ.");
        end_if;
    end;
    
    n := nops(vars);
    
    // retrieve tVar
    if tVar = NIL then
        tVar := daepp::checkDAEInput(eqs, vars)[3];
    end_if;
    
    // convert point to table
    if point <> NIL then
        point := table(point);
    elif options[Constants] = "point" then
        error("Parameter Constants is set as 'point' but no point is designated.")
    end_if;
    
    // prepare new variables
    vars_J := table(j = symobj::diff(vars[j], tVar, q[j] - p[r]) $ j in JJ);
    ngList := indets(eqs, All);
    newVars_J := table(map(JJ, proc(j) local newVar; begin
        newVar := daepp::generateVariable(vars[j], q[j] - p[r], ngList, TimeVariable = tVar);
        ngList := ngList union {newVar};
        j = newVar;
    end_proc));
    
    // select variables for which constants are needed
    circuit := append(II, r);
    S := daepp::orderMatrix([eqs[i] $ i in circuit], vars);
    T := select([j $ j = 1..n],
        j -> max(S[k, j] + p[circuit[k]] $ k = 1..nops(circuit)) = q[j] && contains(JJ, j) = 0);
    if nops(T) = 0 then
        error("Something wrong: T is empty.");
    end_if;
    vars_T := table(j = symobj::diff(vars[j], tVar, q[j] - p[r]) $ j in T);
    
    if options[Constants] = "point" then
        existingT := select(T, j -> contains(point, vars_T[j]));
        missingT := select(T, j -> not contains(point, vars_T[j]));
        missingConstOpt := options[MissingConstants];
    else
        existingT := [];
        missingT := T;
        missingConstOpt := options[Constants];
    end_if;
    
    // prepare constants
    constsForExistingT := table(map(existingT, j -> j = point[vars_T[j]]));
    
    genConst := proc(j)
        local newVar;
        begin
            newVar := daepp::generateVariable(vars[j], q[j] - p[r], ngList,
                TimeVariable = tVar, Prefix = "const", ReturnFunction = FALSE);
            ngList := ngList union {newVar};
            j = newVar;
        end_proc;
    
    constsForMissingT := table(case missingConstOpt
        of "sym"  do map(missingT, genConst); break;
        of "zero" do map(missingT, j -> j = 0); break;
    end_case);
    
    // prepare equations and variables
    eqs_I := [symobj::diff(eqs[i], tVar, p[i] - p[r]) $ i in II];
    
    // substitute
    subseq := map(JJ, j -> vars_J[j] = newVars_J[j])
            . map(existingT, j -> vars_T[j] = constsForExistingT[j])
            . map(missingT, j -> vars_T[j] = constsForMissingT[j]);
    [eqs_r, eqs_I] := map([eqs[r], eqs_I], eq -> subs(eq, subseq));
    
    // append new equations and variables
    newEqs := eqs . eqs_I;
    newEqs[r] := eqs_r;
    newVars := vars . rhs(newVars_J);
    
    // make R and constR
    R := map(JJ, j -> newVars_J[j] = vars_J[j]);
    constR := case missingConstOpt
        of "sym"  do map(missingT, j -> constsForMissingT[j] = vars_T[j]); break;
        of "zero" do []; break;
    end_case;
    
    [newEqs, newVars, R, constR];
end_proc;
