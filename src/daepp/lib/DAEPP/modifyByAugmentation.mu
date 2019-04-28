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

daepp::modifyByAugmentation := proc(eqs, vars, p, q, r, II, JJ /*, tVar */)
local hast, oparg, options, m, n, tVar, eqsIndets, genVar, vars_J, newVars_J,
      circuit, S, T, vars_T, consts, eqs_I, subseq;
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
    hast := is(args(0) > 7 && not testtype(args(8), DOM_TABLE));
    oparg := if hast then 9 else 8 end_if;
    options := prog::getOptions(oparg, [args()], table(Constants = "sym"), TRUE)[1];
    
    // check input
    if testargs() then
        [eqs, vars, tVar] := daepp::checkDAEInput(eqs, vars);
        if hast && tVar <> args(oparg - 1) then
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
    
    // retrieve tVar
    if not hast then
        [eqs, vars, tVar] := daepp::checkDAEInput(eqs, vars);
    else
        tVar := args(oparg - 1);
    end_if;
    
    // procedure for naming new variables
    eqsIndets := indets(eqs, All);
    genVar := proc(var, d, prefix)
        local newName, newVar;
        begin
            // make new name
            newName := expr2text(op(var, 0));
            if d = 0 then
                newName := prefix . newName;
            else
                newName := prefix . "D" . newName . _concat(expr2text(t) $ d);
            end_if;
            
            // make new var
            newVar := DOM_IDENT(newName);
            if domtype(eval(newVar)) <> DOM_IDENT ||
               showprop(newVar(tVar)) <> [] ||
               showprop(newVar) <> [] ||
               contains(eqsIndets, newVar) then
                newVar := genident(newName);
            end_if;
            
            newVar;
        end_proc;
    
    // prepare new variables
    vars_J := [symobj::diff(vars[j], tVar, q[j] - p[r]) $ j in JJ];
    newVars_J := [genVar(vars[j], q[j] - p[r], "")(tVar) $ j in JJ];
    
    // prepare constants
    circuit := append(II, r);
    S := daepp::orderMatrix([eqs[i] $ i in circuit], vars);
    T := select([j $ j = 1..n],
        j -> max(S[k, j] + p[circuit[k]] $ k = 1..nops(circuit)) = q[j] && contains(JJ, j) = 0);
    if nops(T) = 0 then
        error("Something wrong: T is empty.");
    end_if;
    vars_T := [symobj::diff(vars[j], tVar, q[j] - p[r]) $ j in T];
    
    case options[Constants]
        of "sym" do 
            consts := [genVar(vars[j], q[j] - p[r], "const") $ j in T];
            break;
        of "zero" do
            consts := [0 $ nops(T)];
            break;
        otherwise
            error("Invalid parameter of 'Constants'.");
    end_case;
    
    // prepare equations and variables
    eqs_I := [symobj::diff(eqs[i], tVar, p[i] - p[r]) $ i in II];
    
    // substitute
    subseq := [vars_J[k] = newVars_J[k] $ k = 1..nops(JJ)]
            . [vars_T[k] = consts[k] $ k = 1..nops(T)];
    [eqs_r, eqs_I] := map([eqs[r], eqs_I], eq -> subs(eq, subseq));
    
    // append new equations and variables
    newEqs := eqs . eqs_I;
    newEqs[r] := eqs_r;
    newVars := vars . newVars_J;
    
    if options[Constants] = "sym" then
        [newEqs, newVars, consts];
    else
        [newEqs, newVars];
    end_if;
end_proc;
