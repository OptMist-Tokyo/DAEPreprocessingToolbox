/*
  Compute a maximum assignment for an n x n cost matrix M by the Hungarian
  method.
  Also return an optimal solution (p1, ..., pn, q1, ..., qn) of the
  following dual problem:

      minimize    (q_1 + ... + q_n) - (p_1 + ... + p_n)
      subject to  q_j - p_i >= M(i, j)                    (1 <= i, j <= n)
                  q_j and p_i are nonnegative integers    (1 <= i, j <= n)

  Return Values:
      - optval : the optimal value. If M has no perfect matching, this is
                 set to -Inf.
      -      s : the i-th row is assigned to the s(i)-th column
      -      t : the j-th column is assigned to the t(j)-th row
                 (t is the inverse of s as a permutation)
      -      p : optimal dual solution in rows
      -      q : optimal dual solution in columns
*/

daepp::hungarian := proc(M)
local m, n, optval, s, t, p, q, updateSlack, r, slack, slackid, prev,
      findAugmentingPath, v, nextv;
begin
    // check number of arguments
    if testargs() then
        if args(0) <> 1 then
            error("One argument expected.");
        end_if;
    end_if;
    
    // convert to matrix
    M := symobj::tomatrix(M);
    
    // check input
    if testargs() then
        [m, n] := linalg::matdim(M);
        if m <> n then
            error("Square matrix expected.");
        end_if;
        if not _and((testtype(v, Type::Union(DOM_INT, stdlib::Infinity)) && v <> infinity) $ v in M) then
            error("Matrix entries are expected to be integer or -infinity.");
        end_if;
    end_if;
    
    // initialize variables
    n := linalg::ncols(M);
    optval := -infinity;
    s := [-1 $ n];
    t := [-1 $ n];
    p := [0 $ n];
    q := [max(coerce(transpose(linalg::col(M, j)), DOM_LIST)) $ j = 1..n];
    
    if contains(q, -infinity) <> 0 then
        return([optval, s, t, p, q]);
    end_if;
    
    // subroutine for update of slack
    updateSlack := proc(i)
        local j, newslack;
        begin
            for j from 1 to n do
                newslack := q[j] - p[i] - M[i, j];
                if newslack < slack[j] then
                    slack[j] := newslack;
                    slackid[j] := i;
                end_if;
            end_for;
        end_proc;
    
    // r is the root of an augmenting tree
    for r from 1 to n do
        slack := [infinity $ n];
        slackid := [-1 $ n];
        
        updateSlack(r);
        
        // prev[j] := parent of j in the DFS tree (-1 means j does not belong to the tree)
        prev := [-1 $ n];
        
        // subroutine for augmentation
        findAugmentingPath := proc()
            local Q, head, i, j, delta;
            begin
                Q := [r];
                head := 1;
                
                while TRUE do
                    // construct the augmenting tree by BFS
                    while head <= nops(Q) do
                        i := Q[head];
                        head := head + 1;
                        for j from 1 to n do
                            if prev[j] = -1 && q[j] - p[i] = M[i, j] then
                                prev[j] := i;
                                if t[j] = -1 then
                                    return(j); // found an augmenting path!
                                end_if;
                                updateSlack(t[j]);
                                Q := append(Q, t[j]);
                            end_if;
                        end_for;
                    end_while;
                    
                    // update potentials
                    delta := min(map(select(j $ j = 1..n, j -> prev[j] = -1), j -> slack[j]));
                    if delta = infinity then
                        return(-1); // no augmenting math
                    end_if;
                    
                    for i in Q do
                        p[i] := p[i] + delta;
                    end_for;
                    
                    for j from 1 to n do
                        if prev[j] = -1 then
                            slack[j] := slack[j] - delta;
                        else
                            q[j] := q[j] + delta;
                        end_if;
                    end_for;
                    
                    // add vertices to the tree as a result of improving the potentials
                    for j from 1 to n do
                        if prev[j] = -1 && slack[j] = 0 then
                            prev[j] := slackid[j];
                            if t[j] = -1 then
                                return(j); // found an augmenting path!
                            end_if;
                            updateSlack(t[j]);
                            Q := append(Q, t[j]);
                        end_if;
                    end_for;
                end_while;
            end_proc;
        
        v := findAugmentingPath();
        if v = -1 then
            return([optval, s, t, p, q]);
        end_if;
        
        // augment the matching
        while v <> -1 do
            nextv := s[prev[v]];
            t[v] := prev[v];
            s[prev[v]] := v;
            v := nextv;
        end_while;
    end_for;
    
    // compute the optimal value
    optval := _plus(M[i, s[i]] $ i = 1..n);
    [optval, s, t, p, q];
end_proc;
