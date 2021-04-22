// Preprocess DAEs by the mixed matrix method.

daepp::preprocessDAEByMixedMatrix := proc(eqs, vars /*, tVar */)
local tVar, ngList, sVar, Q, T, R, m_Q, U_Q, n, dof, A, S, v, p, q, tcf, tcf_Q,
      tcf_T, rk, J, Utmp, U;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 2 || 3 < args(0) then
            error("Two or three arguments expected.");
        end_if;
    end_if;
    
    // convert to lists
    [eqs, vars] := map([eqs, vars], symobj::tolist);
    
    // check input
    if testargs() then
        [eqs, vars, tVar] := daepp::checkDAEInput(eqs, vars);
        if args(0) = 3 && tVar <> args(3) then
            error("Inconsistency of time variable.");
        end_if;
        if nops(eqs) <> nops(vars) then
            error("Inconsistency of sizes between equations and variables.");
        end_if;
    end_if;
    
    // retrieve tVar
    if args(0) = 2 then
        [eqs, vars, tVar] := daepp::checkDAEInput(eqs, vars);
    else
        tVar := args(3);
    end_if;
    
    // convert to LM-form
    ngList := indets(eqs, All);
    sVar := daepp::generateVariable(NIL, 0, ngList, Prefix = "s", ReturnFunction = FALSE);
    [eqs, vars, Q, T, R] := daepp::convertToLayeredMixed(eqs, vars, tVar, sVar);
    if nops(eqs) <> nops(vars) then
        error("There is no perfect matching between equations and variables. "
            . "This means that the solution space might be of infinite dimensional.");
    end_if;
    
    m_Q := linalg::matdim(Q)[1];
    U_Q := if m_Q = 0 then [] else matrix::identity(m_Q) end_if;
    n := nops(eqs);
    dof := infinity;
    
    // main loop
    while TRUE do
        // Phase 1: Solve Assignment Problem
        A := linalg::stackMatrix(Q, T);
        S := map(A, v -> if v = 0 then -infinity else degree(v) end_if);
        [v, p, q] := daepp::hungarian(S)[[1, 4, 5]];
        
        if v = -infinity then
            error("There is no perfect matching between equations and variables. "
                . "This means that the solution space might be of infinite dimensional.");
        end_if;
        if dof <= v then
            error("The optimal value of the assignment problem does not decrease.");
        end_if;
        dof := v;
        
        // corner case
        if m_Q = 0 then
            return([eqs, vars, dof, R]);
        end_if;
        
        // Phase 2: Check the Nonsingularity of Tight Coefficient Matrix
        tcf := matrix(n, n, (i, j) -> if q[j] - p[i] = degree(A[i, j]) then lcoeff(A[i, j]) else 0 end_if);
        tcf_Q := tcf[1..m_Q, 1..n];
        tcf_T := tcf[(m_Q+1)..n, 1..n];
        [rk, J] := daepp::LMMatrixRank(tcf_Q, tcf_T);
        
        if rk = n then
            break;
        end_if;
        
        // Phase 3: Modify Matrix
        Utmp := daepp::computeModifyingMatrix(tcf_Q[1..m_Q, J]), p, sVar);
        Q := Utmp * Q;
        U_Q := Utmp * U_Q;
    end_while;
    
    // Modify DAE
    U := linalg::substitute(matrix::identity(n), U_Q, 1, 1);
    eqs := daepp::applyPolynomialMatrix(eqs, vars, U, tVar);
    
    // return
    [eqs, vars, dof, R];
end_proc;
