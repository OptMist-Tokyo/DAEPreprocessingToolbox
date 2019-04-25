/*
  Guass--Jordan elimination.
  pivcol is the list of column indices such that pivcol[i] is the i-th pivot for
  all i, that is, the pivcol[i]-th column has 1 for the i-th row and 0 for others.
*/

daepp::gaussJordan := proc(A /*, values */)
local values, rank, det, pivcol, V, m, n, q, k, s, t, maxv, i, j, newA;
begin
    // check number of arguments
    if args(0) < 1 || 2 < args(0) then
        error("One or two argument(s) expected.");
    end_if;
    
    // convert to a matrix
    A := symobj::tomatrix(A);
    
    // if values is not provided, apply the usual Gaussian elimination
    if args(0) = 1 then
        [A, rank, det, pivcol] := linalg::gaussJordan(A, All);
        pivcol := sort(coerce(pivcol, DOM_LIST));
        return([A, rank, pivcol]);
    end_if;
    
    // retrieve values
    values := args(2);
    if testargs() then
        values := daepp::checkValuesInput(values);
    end_if;
    
    // make a constant matrix V
    V := float(subs(A, values));
    if not _and(type(v) in {DOM_INT, DOM_FLOAT} $ v in V) then
        error("Some assignments are missing.");
    end_if;
    
    [m, n] := linalg::matdim(A);
    q := [j $ j = 1..n];
    
    // Gaussian elimination for determinating pivot
    for k from 1 to min(m, n) do
        // search for the largest entry (pivot)
        [s, t] := [k, k];
        maxv := 0.0;
        for i from k to m do
            for j from k to n do
                if maxv < abs(V[i, j]) then
                    [s, t] := [i, j];
                    maxv := abs(V[i, j]);
                end_if;
            end_for;
        end_for;
        
        if maxv = 0.0 then
            break;
        end_if;
        
        // swap rows and columns so that the pivot (s, t) comes to (k, k)
        [q[k], q[t]] := [q[t], q[k]];
        V := linalg::swapRow(V, k, s);
        V := linalg::swapCol(V, k, t);
        A := linalg::swapRow(A, k, s);
        A := linalg::swapCol(A, k, t);
        
        // eliminate
        for i from k+1 to m do
            V := linalg::addRow(V, k, i, -V[i, k] / V[k, k]);
            V[i, k] := 0;
        end_for;
    end_for;
    
    // elimination on permuted A
    [A, rank, det, pivcol] := linalg::gaussJordan(A, All);
    pivcol := sort(coerce(pivcol, DOM_LIST));
    
    // permute back the colums of A
    newA := matrix(m, n);
    for j from 1 to n do
        newA := linalg::setCol(newA, q[j], linalg::col(A, j));
    end_for;
    pivcol := [q[j] $ j in pivcol];
    
    [newA, rank, pivcol];
end_proc;
