// MuPAD implementation for modifyBySubstiution.m

daepp::modifyBySubstitution := proc(eqs, vars, p, q, r, II, JJ /*, tVar */)
local m, n, tVar, vars_J, dummy_J, circuit, S, T, vars_T, dummy_T, eqs_I, subseq, out;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 7 || 8 < args(0) then
            error("Seven or eight arguments expected.");
        end_if;
    end_if;
    
    // convert to lists
    [eqs, vars, p, q, II, JJ] := map([eqs, vars, p, q, II, JJ], symobj::tolist);
    
    // check input
    if testargs() then
        [eqs, vars, tVar] := daetools::checkInput(eqs, vars, "AllowOnlyFuncVars");
        if args(0) = 8 && tVar <> args(8) then
            error("Inconsistency of time variable.");
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
        if not _and((p[r] <= p[i]) $ i in II) then
            error("p[r] is not minimum in p[i] for i in II.");
        end_if;
        if not _and((testtype(n, DOM_INT) && 1 <= j && j <= n) $ j in JJ) then
            error("Invalid indices in JJ.");
        end_if;
    end;
    
    n := nops(vars);
    
    // retrive tVar
    if args(0) = 7 then
        [eqs, vars, tVar] := daepp::checkInput(eqs, vars);
    else
        tVar := args(8);
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
    out := solve(eqs_I, dummy_J, IgnoreSpecialCases, IgnoreAnalyticConstraints);
    if testtype(out, piecewise) then
        out := out[1];
    end_if;
    
    if nops(out) = 0 then
        error("Could not solve equation system. Try augmenting method.");
    end_if;
    
    // substitute
    eqs[r] := subs(eqs_r, out[1]);
    eqs[r] := simplify(collect(eqs[r], dummy_T), IgnoreAnalyticConstraints);
    
    if has(eqs[r], dummy_T) then
        error("Something wrong: variables did not cancel.");
    end_if;
    
    eqs;
end_proc;