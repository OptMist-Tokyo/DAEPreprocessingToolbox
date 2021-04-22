/*
  Guass--Jordan elimination.
  
  Return Values;
      newA : eliminated matrix
      rank : rank of matrix
      pivcol : the list of column indices such that pivcol[i] is the i-th pivot
               for all i; that is, the pivcol[i]-th column has 1 for the i-th
               row and 0 for others.
  
  V is used to avoid using near-zero pivots.
*/

daepp::gaussJordan := proc(A /*, V */)
local rank, pivcol, V, p, q, m, n, newA, j;
begin
    // check number of arguments
    if args(0) < 1 || 2 < args(0) then
        error("One or two argument(s) expected.");
    end_if;
    
    // convert to a matrix
    A := symobj::tomatrix(A);
    
    // if values is not provided, apply the usual Gaussian elimination
    if args(0) = 1 then
        [A, rank, pivcol] := linalg::gaussJordan(A, All)[[1, 2, 4]];
        pivcol := sort(coerce(pivcol, DOM_LIST));
        return([A, rank, pivcol]);
    end_if;
    
    // retrieve V
    V := args(2);
    if testargs() then
        if not _and(testtype(v, Type::Real) $ v in V) then
            error("Expected V not contains symbols.");
        end_if;
    end_if;
    
    // determine pivots p, q
    [p, q] := daepp::greedyPivoting(V)[[1, 2]];
    [m, n] := linalg::matdim(A);
    
    // permute A according to p, q
    A := matrix(m, n, (i, j) -> A[p[i], q[j]]);
    
    // elimination on permuted A
    [A, rank, pivcol] := linalg::gaussJordan(A, All)[[1, 2, 4]];
    pivcol := sort(coerce(pivcol, DOM_LIST));
    
    // permute back the colums of A
    newA := matrix(m, n);
    for j from 1 to n do
        newA := linalg::setCol(newA, q[j], linalg::col(A, j));
    end_for;
    pivcol := [q[j] $ j in pivcol];
    
    [newA, rank, pivcol];
end_proc;
