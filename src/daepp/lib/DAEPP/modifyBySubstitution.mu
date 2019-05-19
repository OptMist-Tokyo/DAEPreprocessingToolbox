// MuPAD implementation for modifyBySubstiution.m

daepp::modifyBySubstitution := proc(eqs, vars, p, q, r, II, JJ)
local options, tVar, point, tTmp, m, n, vars_J, dummy_J, circuit, S, T, vars_T,
      dummy_T, eqs_I, subseq, eqs_r, solutions, backsubseq, minerror, sol, s,
      lhsValue, rhsValue, err, bestsol;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 7 || 8 < args(0) then
            error("Seven or eight arguments expected.");
        end_if;
    end_if;
    
    // convert to lists
    [eqs, vars, p, q, II, JJ] := map([eqs, vars, p, q, II, JJ], symobj::tolist);

    // get options
    options := prog::getOptions(8, [args()], table(TimeVariable = NIL, Point = NIL), TRUE)[1];
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
    
    // prepare variables
    vars_J := [symobj::diff(vars[j], tVar, q[j] - p[r]) $ j in JJ];
    dummy_J := [genident() $ j in JJ];
    
    // prepare variables to be canceled
    circuit := append(II, r);
    S := daepp::orderMatrix([eqs[i] $ i in circuit], vars);
    T := select([j $ j = 1..n],
        j -> max(S[k, j] + p[circuit[k]] $ k = 1..nops(circuit)) = q[j] && contains(JJ, j) = 0);
    vars_T := [symobj::diff(vars[j], tVar, q[j] - p[r]) $ j in T];
    dummy_T := [genident() $ j in T];
    
    // prepare equations
    eqs_I := [symobj::diff(eqs[i], tVar, p[i] - p[r]) $ i in II];
    subseq := [vars_J[k] = dummy_J[k] $ k = 1..nops(JJ)] . [vars_T[k] = dummy_T[k] $ k = 1..nops(T)];
    [eqs_r, eqs_I] := map([eqs[r], eqs_I], eq -> subs(eq, subseq));
    
    // solve
    solutions := solve(eqs_I, dummy_J, IgnoreSpecialCases, IgnoreAnalyticConstraints);
    if testtype(solutions, piecewise) then
        solutions := solutions[1];
    end_if;
    
    if nops(solutions) = 0 then
        error("Could not solve equation system. Try augmenting method.");
    elif nops(solutions) > 1 then
        if point <> NIL then
            // try to find a solution corresponding to point
            backsubseq := [dummy_J[k] = vars_J[k] $ k = 1..nops(JJ)] . [dummy_T[k] = vars_T[k] $ k = 1..nops(T)];
            minerror := infinity;
            for sol in solutions do
                s := subs(sol, backsubseq);
                lhsValue := eval(daepp::substitutePoint(lhs(s), point));
                rhsValue := eval(daepp::substitutePoint(rhs(s), point));
                err := norm(matrix(lhsValue) - matrix(rhsValue));
                if err < minerror then
                    minerror := err;
                    bestsol := sol;
                end_if;
            end_for;
            
            solutions := [bestsol];
        else
            warning(
                  "Multiple solutions obtained and selected one of them. This may "
                . "shrink the domain of the resulting DAE. Specify initial point to "
                . "choose the appropriate solution."
            );
        end_if;
    end_if;
    
    // substitute
    eqs[r] := subs(eqs_r, solutions[1]);
    eqs[r] := simplify(collect(eqs[r], dummy_T), IgnoreAnalyticConstraints);
    
    if has(eqs[r], dummy_T) then
        error("Something wrong: variables did not cancel.");
    end_if;
    
    eqs;
end_proc;
