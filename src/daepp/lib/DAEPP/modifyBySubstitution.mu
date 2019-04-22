// MuPAD implementation for modifyBySubstiution.m

daepp::modifyBySubstitution := proc(eqs, vars, p, q, r, II, JJ /*, t */)
local m, n, t, vars_J, dummy, eqs_I, subseq, out;
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
        [eqs, vars, t] := daetools::checkInput(eqs, vars, "AllowOnlyFuncVars");
        if args(0) = 8 && t <> args(8) then
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
    
    // retrive t
    if args(0) = 7 then
        [eqs, vars, t] := daepp::checkInput(eqs, vars);
    else
        t := args(8);
    end_if;
    
    // prepare equations and variables
    vars_J := [symobj::diff(vars[j], t, q[j] - p[r]) $ j in JJ];
    dummy := [genident() $ j in JJ];
    eqs_I := [symobj::diff(eqs[i], t, p[i] - p[r]) $ i in II];
    subseq := [vars_J[k] = dummy[k] $ k = 1..nops(JJ)];
    [eqs_r, eqs_I] := map([eqs[r], eqs_I], eq -> subs(eq, subseq));
    
    // solve
    out := solve(eqs_I, dummy, Real, IgnoreSpecialCases, IgnoreAnalyticConstraints);
    if testtype(out, piecewise) then
        out := out[1];
    end_if;
    
    // substitute
    eqs[r] := simplify(subs(eqs_r, out[1]), IgnoreAnalyticConstraints);
    
    eqs;
end_proc;
