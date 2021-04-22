/*
  Compute a unimodular matrix U(s) such that
  the delta-hat of [U(s)Q(s); T(s)] is less than that of [Q(s); T(s)].
  The given Q is the TCF of Q(s) with dual optimal solution (p, *).
*/

daepp::computeModifyingMatrix := proc(Q, p /*, sVar */)
local m, n, sVar, perm, U, i, piv_j, j, h, w;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 2 || 3 < args(0) then
            error("Two or three arguments expected.");
        end_if;
    end_if;
    
    // convert to a matrix and lists
    Q := symobj::tomatrix(Q);
    p := symobj::tolist(p);
    [m, n] := linalg::matdim(Q);
    
    // check input
    if testargs() then
        if m <> nops(p) then
            error("Inconsistency between the row size of Q and the size of p.");
        end_if;
        if not _and(testtype(pi, DOM_INT) $ pi in p) then
            error("Entries in p are expected to be integers.");
        end_if;
    end_if;
    
    // retrieve sVar
    if args(0) = 2 then
        sVar := daepp::generateVariable(NIL, 0, {}, Prefix = "s", ReturnFunction = FALSE);
    else
        sVar := args(3);
        if not testtype(sVar, DOM_IDENT) then
            error("Third argument must be an identifier.");
        end_if;
    end_if;
    
    // empty cases
    if m = 0 then
        return(matrix(0, 0));
    elif n = 0 then;
        return(matrix::identity(m));
    end_if;
    
    // Permute rows of Q in descending order of p
    perm := [data[2] $ data in sort([[-p[i], i] $ i = 1..m])];
    Q := Q[perm, 1..n];
    
    // Gaussian elimination
    U := matrix::identity(m);
    for i from 1 to m do
        piv_j := -1;
        for j from 1 to n do
            if Q[i, j] <> 0 then
                piv_j := j;
                break;
            end_if;
        end_for;
        
        if piv_j = -1 then
            break;
        end_if;
        
        for h from i+1 to m do
            w := -Q[h, j] / Q[i, piv_j];
            Q := linalg::addRow(Q, i, h, w);
            U := linalg::addRow(U, perm[i], perm[h], w);
        end_for;
    end_for;
    
    // compute and return U(s)
    matrix(m, m, (i, j) -> if U[i, j] = 0 then 0 else U[i, j] * sVar^(p[j]-p[i]) end_if);
end_proc;
