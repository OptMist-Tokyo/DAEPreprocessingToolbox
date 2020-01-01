/*
  Compute the rank of LM-matrix A = [Q; T].
  Returned J satisfy the following min-max relation:
  
  rank A = min {rank Q[R_Q, J] + t-rank T[R_T, J] + |C \ J| | J \subseteq C}.
*/

daepp::LMMatrixRank := proc(Q, T)
local m_Q, m_T, n, R_T, C_Q, C, matching, matched_T, base, base_inv,
      search_shortest_path, prev_R_T, prev_C_Q, prev_C, v, u, t, j, h, i, rk, J;
begin
    // check number of arguments
    if testargs() then
        if args(0) <> 2 then
            error("Two argument expected.");
        end_if;
    end_if;
    
    // convert to matrices
    [Q, T] := map([Q, T], symobj::tomatrix);
    [m_Q, m_T] := map([Q, T], A -> linalg::matdim(A)[1]);
    n := linalg::matdim(Q)[2];
    
    // check input
    if testargs() then
        if n <> linalg::matdim(T)[2] then
            error("Inconsistent column sizes between Q and T.");
        end_if;
    end_if;
    
    [R_T, C_Q, C] := [0, 1, 2];
    matching  := [[NIL, -1] $ j = 1..n]; // C -> R_T \cup R_Q
    matched_T := [FALSE $ i = 1..m_T];   // R_T -> {TRUE, FALSE}
    base      := [   -1 $ h = 1..m_Q];   // R_Q -> C
    base_inv  := [   -1 $ j = 1..n];     // C -> R_Q
    
    // procedure for searching shortest augmenting path
    search_shortest_path := proc()
    local queue, i, h, j, head, v, add_C, type, id;
    begin
        queue := [];
        prev_R_T := [[NIL, -1] $ i = 1..m_T];
        
        // push start vertices in R_T
        for i from 1 to m_T do
            if not matched_T[i] then
                prev_R_T[i][2] := 0;
                queue := append(queue, [R_T, i]);
            end_if;
        end_for;
        
        // push start vertices in C_Q
        prev_C_Q := [[NIL, -1] $ h = 1..n];
        for h from 1 to m_Q do
            if base[h] = -1 then
                for j from 1 to n do
                    if prev_C_Q[j][2] = -1 and Q[h, j] <> 0 then
                        prev_C_Q[j][2] := 0;
                        queue := append(queue, [C_Q, j]);
                    end_if;
                end_for;
            end_if;
        end_for;
        
        prev_C := [[NIL, -1] $ j = 1..n];
        
        // BFS
        head := 1;
        while head <= nops(queue) do
            v := queue[head];
            head := head + 1;
            
            add_C := proc(j, prev) begin // returns TRUE is augment is succeeded
                prev_C[j] := prev;
                if matching[j][1] = NIL then
                    TRUE
                else
                    queue := append(queue, [C, j]);
                    FALSE
                end_if;
            end_proc;
            
            if v[1] = R_T then
                for j from 1 to n do
                    if T[v[2], j] <> 0 and prev_C[j][2] = -1 then
                        if add_C(j, v) then [C, return(j)] end_if;
                    end_if;
                end_for;
            elif v[1] = C_Q then
                if prev_C[v[2]][2] = -1 then
                    if add_C(v[2], v) then [C, return(v[2])] end_if;
                end_if;
                
                // hige
                h := base_inv[v[2]];
                if h <> -1 then
                    for j from 1 to n do
                        if Q[h, j] <> 0 and prev_C_Q[j][2] = -1 then
                            prev_C_Q[j] := v;
                            queue := append(queue, [C_Q, j]);
                        end_if;
                    end_for;
                end_if;
            else // v[1] = C
                [type, id] := matching[v[2]];
                if type = R_T then
                    if prev_R_T[id][2] = -1 then
                        prev_R_T[id] := v;
                        queue := append(queue, [type, id]);
                    end_if;
                elif type = C_Q then
                    if prev_C_Q[id][2] = -1 then
                        prev_C_Q[id] := [type, id];
                        queue := append(queue, [type, id]);
                    end_if;
                end_if;
            end_if;
        end_while;
        
        [NIL, -1]
    end_proc;
    
    // main loop
    while TRUE do
        v := search_shortest_path();
        if v[1] = NIL then
            break;
        end_if;
        
        while v[1] <> NIL do
            u := prev_C[v[2]]; // u -> v
            matching[v[2]] := u;
            
            if u[1] = R_T then
                matched_T[u[2]] := TRUE;
                t := prev_R_T[u[2]];
                if t[1] = NIL then
                    break;
                end_if;
                v := t;
            else
                pivot := proc(h, j, piv) local k;
                    begin
                        for k from 1 to m_Q do
                            if k <> h then
                                Q := linalg::addRow(Q, h, k, -Q[k, j] / piv);
                            end_if;
                        end_for;
                    end_proc;
                
                j := u[2];
                t := prev_C_Q[j]; // t -> u -> v
                if t[1] = NIL then
                    // add the j-th column to the base
                    for h from 1 to m_Q do
                        if base[h] = -1 and Q[h, j] <> 0 then
                            base[h] := j;
                            base_inv[j] := h;
                            pivot(h, j, Q[h, j]);
                            break;
                        end_if;
                    end_for;
                    break;
                else
                    // Through hige. Remove the i-th column and add the j-th column
                    i := t[2];
                    h := base_inv[i];
                    base[h] := j;
                    base_inv[i] := -1;
                    base_inv[j] := h;
                    pivot(h, j, Q[h, j]);
                    v := prev_C_Q[i];
                end_if;
            end_if;
        end_while;
    end_while;
    
    // accumulate the result
    rk := if n > 0 then nops(select(map(matching, v -> v[1]), v1 -> v1 <> NIL)) else 0 end_if;
    J := [select(j $ j = 1..n, j -> prev_C[j][2] = -1)];
    
    // return
    [rk, J]
end_proc;
