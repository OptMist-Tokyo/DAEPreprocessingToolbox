// MuPAD implementation for reduceIndex.m

daepp::reduceIndex := proc(eqs, vars)
local options, tVar, point, tTmp, m, n, S, v, p, q, D, V, II, JJ, h, k, subD,
      rank, piv, newJJ, j, newEqs, diffVars, N, ngList, dummyVars, newVars, R,
      pointTable, newPoint;
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
    options := prog::getOptions(3, [args()], table(TimeVariable = NIL, Point = NIL), TRUE)[1];
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
    
    [m, n] := [nops(eqs), nops(vars)];
    
    // retrieve tVar
    if tVar = NIL then
        tVar := daepp::checkDAEInput(eqs, vars)[3];
    end_if;
    
    // get system Jacobian
    S := daepp::orderMatrix(eqs, vars);
    [v, p, q] := daepp::hungarian(S)[[1, 4, 5]];
    if v = -infinity then
        error("There is no perfect matching between equations and variables.");
    end_if;
    D := daepp::systemJacobian(eqs, vars, p, q, tVar);
    if point <> NIL then
        V := daepp::substitutePoint(D, point);
    end_if;
    
    // find k : k[i] is the largest integer such that ...
    II := [i $ i = 1..m];
    JJ := [j $ j = 1..n];
    h := 0;
    k := [0 $ n];
    
    while TRUE do
        II := select(II, i -> p[i] >= h);
        if nops(II) = 0 then
            break;
        end_if;
        
        subD := linalg::submatrix(D, II, JJ);
        if point <> NIL then
            [rank, piv] := daepp::gaussJordan(subD, linalg::submatrix(V, II, JJ))[[2, 3]];
        else
            [rank, piv] := daepp::gaussJordan(subD)[[2, 3]];
        end_if;
        
        if rank < nops(II) then
            error("System Jacobian may not be of full-row rank. Apply preprocessDAE beforehand.");
        end_if;
        
        newJJ := [JJ[j] $ j in piv];
        
        for j in newJJ do
            k[j] := h;
        end_for;
        
        JJ := newJJ;
        h := h + 1;
    end_while;
    
    // differentiate equations
    newEqs := eqs . _concat([symobj::diff(eqs[i], tVar, d) $ d = 1..p[i]] $ i = 1..m);
    
    // prepare dummy variables
    diffVars := _concat([symobj::diff(vars[j], tVar, d) $ d = (q[j]-k[j]+1)..q[j]] $ j = 1..n);
    N := nops(diffVars);
    ngList := indets(newEqs, All);
    dummyVars := _concat(map([d $ d = (q[j]-k[j]+1)..q[j]], proc(d)
        local var;
        begin
            var := daepp::generateVariable(vars[j], d, ngList, TimeVariable = tVar);
            ngList := ngList union {var};
            var;
        end_proc) $ j = 1..n);
    
    // substitute
    newEqs := subs(newEqs, [diffVars[j] = dummyVars[j] $ j = 1..N]);
    newVars := vars . dummyVars;
    R := matrix(N, 2, (j, i) -> if i = 1 then diffVars[j] else dummyVars[j] end_if);
    
    if point <> NIL then
        pointTable := table(point);
        newPoint := point . [dummyVars[j] = pointTable[diffVars[j]] $ j = 1..N];
        [newEqs, newVars, R, newPoint];
    else;
        [newEqs, newVars, R];
    end_if;
end_proc;
