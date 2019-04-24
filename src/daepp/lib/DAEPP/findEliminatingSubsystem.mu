// MuPAD implementation for findEliminatingSubsystem.m

daepp::findEliminatingSubsystem := proc(D, p)
local m, n, A, rank, det, pivrow, nonpiv, circuit, i, circuitCand, pmin, rcand, r, II, JJ;
begin
    // check number of arguments
    if args(0) <> 2 then
        error("Two arguments expected.");
    end_if;
    
    // convert to matrix and list
    [D, p] := [symobj::tomatrix(D), symobj::tolist(p)];
    
    // check input
    if testargs() then
        if linalg::nrows(D) <> nops(p) then
            error("Inconsistency between sizes of rows in M and p.");
        end_if;
        if not _and((testtype(pi, DOM_INT) && pi >= 0) $ pi in p) then
            error("Entries in p are expected to be nonnegative integers.");
        end_if;
    end_if;
    
    [m, n] := linalg::matdim(D);
    
    // row operations
    [A, rank, det, pivrow] := linalg::gaussJordan(transpose(D), All);
    A := transpose(A);
    
    // the case where D is nonsingular
    if rank = m then
        return([0, [], []]);
    end_if;
    
    // find a circuit II union {r}
    nonpiv := {i $ i = 1..m} minus pivrow;
    circuit := {i $ i = 1..m};
    for i in nonpiv do
        circuitCand := {select(j $ j = 1..n, j -> not linalg::zeroTest(expr(A[i, j])))} union {i};
        if nops(circuitCand) < nops(circuit) then
            circuit := circuitCand;
        end_if;
    end_for;
    
    // separate r from circuit
    pmin := min(p[i] $ i in circuit);
    rcand := select(circuit, i -> p[i] = pmin);
    r := rcand[1];
    II := sort(coerce(circuit minus {r}, DOM_LIST));
    
    // determine JJ
    [A, rank, det, JJ] := linalg::gaussJordan(linalg::submatrix(D, II, [j $ j = 1..n]), All);
    JJ := sort(coerce(JJ, DOM_LIST));
    
    [r, II, JJ];
end_proc;
