/*
  The Gaussian elimination on V. The i-th pivot (p[i], q[i]) is greedily
  determined so that it has the largest absolute value. absDet is an
  approximatelylargest absolute value of the determinant of a submatrix with
  size min(n, m), where (n, m) is the size of V.
*/

daepp::greedyPivoting := proc(V)
local m, n, p, q, absDet, k, s, t, maxv, i, j;
begin
    // check number of arguments
    if args(0) <> 1 then
        error("One argument expected.");
    end_if;
    
    // convert to a matrix
    V := symobj::tomatrix(V);
    
    // check input
    if testargs() then
        if not _and(testtype(v, Dom::Real) $ v in V) then
            error("Float or real entries expected.");
        end_if;
    end_if;
    
    [m, n] := linalg::matdim(V);
    p := [i $ i = 1..m];
    q := [j $ j = 1..n];
    absDet := 1;
    
    // main loop
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
        
        if iszero(maxv) then
            absDet := 0;
            break;
        end_if;
        
        // swap rows and columns so that the pivot (s, t) comes to (k, k)
        [p[k], p[s]] := [p[s], p[k]];
        [q[k], q[t]] := [q[t], q[k]];
        V := linalg::swapRow(V, k, s);
        V := linalg::swapCol(V, k, t);
        absDet := absDet * V[k, k];
        
        // eliminate
        for i from k+1 to m do
            V := linalg::addRow(V, k, i, -V[i, k] / V[k, k]);
            V[i, k] := 0;
        end_for;
    end_for;
    
    [p, q, abs(absDet)];
end_proc;
