/*
  Find a row r, a row subset I not containing r and a column subset J such that
      - (C1): D(I, J) is nonsingular
      - (C2): rank D([I r], :) = m
      - (C3): p(r) ≦ p(i) for all i in I
  
  V is used to avoid using near-zero pivots.
*/

daepp::findEliminatingSubsystem := proc(D, p /*, V */)
local V, m, n, A, rank, pivrow, nonpiv, circuit, i, circuitCand,
      circuitCandSize, c, maxAbsDet, tmpr, tmpII, pmin, rcand, r, II, subD, JJ;
begin
    // check number of arguments
    if args(0) < 2 || 3 < args(0) then
        error("Two or three arguments expected.");
    end_if;
    
    // convert to matrix and list
    [D, p] := [symobj::tomatrix(D), symobj::tolist(p)];
    warining(expr2text(D));
    
    // check input
    if testargs() then
        if linalg::nrows(D) <> nops(p) then
            error("Inconsistency between sizes of rows in M and p.");
        end_if;
        if not _and((testtype(pi, DOM_INT) && pi >= 0) $ pi in p) then
            error("Entries in p are expected to be nonnegative integers.");
        end_if;
    end_if;
    
    // retrieve V
    if args(0) = 3 then
        V := args(3);
        if testargs() then
            if not _and(testtype(v, Dom::Real) $ v in V) then
                error("Expected V not contains symbols.");
            end_if;
        end_if;
    end_if;
    
    [m, n] := linalg::matdim(D);
    
    // column operations
    if args(0) = 2 then
        [A, rank, pivrow] := daepp::gaussJordan(transpose(D));
    else
        [A, rank, pivrow] := daepp::gaussJordan(transpose(D), transpose(V));
    end_if;
    A := transpose(A);
    
    // the case where D is nonsingular
    if rank = m then
        return([0, [], []]);
    end_if;
    
    // find circuit candidates
    nonpiv := {i $ i = 1..m} minus {i $ i in pivrow};
    circuitCand := {};
    circuitCandSize := m;
    for i in nonpiv do
        c := {map(
            select(j $ j = 1..n, j -> not linalg::zeroTest(expr(A[i, j]))),
            j -> pivrow[j]
        )} union {i};
        if nops(c) < circuitCandSize then
            circuitCand := {c};
            circuitCandSize := nops(c);
        elif nops(c) = circuitCandSize then
            circuitCand := circuitCand union {c};
        end_if;
    end_for;
    
    if args(0) = 2 then
        // separate r from circuit
        circuit := circuitCand[1];
        pmin := min(p[i] $ i in circuit);
        rcand := select(circuit, i -> p[i] = pmin);
        r := rcand[1];
        II := sort(coerce(circuit minus {r}, DOM_LIST))
    else
        // find the best circuit in terms that I has the largest absolute value of the determinant
        maxAbsDet := -1;
        for circuit in circuitCand do
            pmin := min(p[i] $ i in circuit);
            rcand := select(circuit, i -> p[i] = pmin);
            for tmpr in rcand do
                tmpII := coerce(circuit minus {tmpr}, DOM_LIST);
                absDet := daepp::greedyPivoting(linalg::submatrix(V, tmpII, [j $ j = 1..n]))[3];
                if absDet > maxAbsDet then
                    maxAbsDet := absDet;
                    r := tmpr;
                    II := tmpII;
                end_if;
            end_for;
        end_for;
        II := sort(coerce(II, DOM_LIST));
    end_if;
    
    // determine JJ
    subD := linalg::submatrix(D, II, [j $ j = 1..n]);
    
    if args(0) = 2 then
        JJ := daepp::gaussJordan(subD)[3];
    else
        JJ := daepp::gaussJordan(subD, linalg::submatrix(V, II, [j $ j = 1..n]))[3];
    end_if;
    JJ := sort(JJ);
    
    [r, II, JJ];
end_proc;
