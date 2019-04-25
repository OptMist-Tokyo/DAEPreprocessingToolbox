/*
  Find a row r, a row subset I not containing r and a column subset J such that
      - (C1): D(I, J) is nonsingular
      - (C2): rank D([I r], :) = m
      - (C3): p(r) ≦ p(i) for all i in I
*/

daepp::findEliminatingSubsystem := proc(D, p /*, values */)
local values, m, n, Dt, A, rank, pivrow, nonpiv, circuit, i, circuitCand, pmin,
      rcand, r, II, subD, JJ;
begin
    // check number of arguments
    if args(0) < 2 || 3 < args(0) then
        error("Two or three arguments expected.");
    end_if;
    
    // convert to matrix and list
    [D, p] := [symobj::tomatrix(D), symobj::tolist(p)];
    
    // retrieve values
    if args(0) = 3 then
        values := args(3);
    end_if;
    
    // check input
    if testargs() then
        if linalg::nrows(D) <> nops(p) then
            error("Inconsistency between sizes of rows in M and p.");
        end_if;
        if not _and((testtype(pi, DOM_INT) && pi >= 0) $ pi in p) then
            error("Entries in p are expected to be nonnegative integers.");
        end_if;
        if args(0) = 3 then
            checkValuesInput(values);
        end_if;
    end_if;
    
    [m, n] := linalg::matdim(D);
    
    // row operations
    Dt := transpose(D);
    [A, rank, pivrow] := if args(0) = 2 then daepp::gaussJordan(Dt) else daepp::gaussJordan(Dt, values) end_if;
    A := transpose(A);
    
    // the case where D is nonsingular
    if rank = m then
        return([0, [], []]);
    end_if;
    
    // find a circuit II union {r}
    nonpiv := {i $ i = 1..m} minus {i $ i in pivrow};
    circuit := {i $ i = 1..m};
    for i in nonpiv do
        circuitCand := {map(
            select(j $ j = 1..n, j -> not linalg::zeroTest(expr(A[i, j]))),
            j -> pivrow[j]
        )} union {i};
        if nops(circuitCand) < nops(circuit) then
            circuit := circuitCand;
        end_if;
    end_for;
    
    // separate r from circuit
    pmin := min(p[i] $ i in circuit);
    rcand := select(circuit, i -> p[i] = pmin);
    r := rcand[1]; // TODO
    II := sort(coerce(circuit minus {r}, DOM_LIST));
    
    // determine JJ
    subD := linalg::submatrix(D, II, [j $ j = 1..n]);
    [A, rank, JJ] := if args(0) = 2 then daepp::gaussJordan(subD) else daepp::gaussJordan(subD, values) end_if;
    JJ := sort(JJ);
    
    [r, II, JJ];
end_proc;
