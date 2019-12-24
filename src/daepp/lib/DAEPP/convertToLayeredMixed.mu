/*
  Convert DAEs to layered mixed (LM) form.

  Ex.) A(s) x = f
  -->
  [ Q(s)  I ][x] = [f]  ... constant parts
  [ T(s) -I ][y]   [0]  ... nonlinear or parametric parts

  The coefficients of entries in T(s) should be treated as algebraically independent.
*/

daepp::convertToLayeredMixed := proc(eqs, vars /*, tVar */)
local tVar, S, m, n, orders, J, dummy, dummy_eqs, k, J_k, subseqs, Q, T, s, i,
      one_j, one_k, j, deriv, Q_eqs, T_eqs, Q_rows, T_rows, subm, Qi, Ti,
      ngList, nint, cnt, gen_name, newVar;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 2 || 3 < args(0) then
            error("Two or three arguments expected.");
        end_if;
    end_if;
    
    // convert to lists
    [eqs, vars] := map([eqs, vars], symobj::tolist);
    
    // check input
    if testargs() then
        [eqs, vars, tVar] := daepp::checkDAEInput(eqs, vars);
        if args(0) = 3 && tVar <> args(3) then
            error("Inconsistency of time variable.");
        end_if;
    end_if;
    
    // retrieve tVar
    if args(0) = 2 then
        [eqs, vars, tVar] := daepp::checkDAEInput(eqs, vars);
    else
        tVar := args(3);
    end_if;
    
    // compute differential order of each variable
    S := daepp::orderMatrix(eqs, vars);
    [m, n] := linalg::matdim(S);
    orders := if m > 0 then
        [max(coerce(transpose(linalg::col(S, j)), DOM_LIST)) $ j = 1..n]
    else
        [-infinity $ j = 1..n]
    end_if;
    
    // create dummy variables
    J := [select(j $ j = 1..n, j -> orders[j] > -infinity)];
    dummy := [[genident() $ k = 0..orders[j]] $ j in J];
    
    // change symbolic functions to variables
    dummy_eqs := eqs;
    if nops(J) > 0 then
        for k from max(orders) downto 0 do
            J_k := [select(jj $ jj = 1..nops(J), jj -> orders[J[jj]] >= k)];
            subseqs := [symobj::diff(vars[J[jj]], tVar, k) = dummy[jj][k+1] $ jj in J_k];
            dummy_eqs := subs(dummy_eqs, subseqs);
        end_for;
    end_if;
    
    // make an LM-polynomial matrix [Q; T]
    Q := matrix(m, n);
    T := matrix(m, n);
    s := daepp::generateVariable(NIL, 0, {}, Prefix = "s", ReturnFunction = FALSE);
    
    for i from 1 to m do
        [one_j, one_k] := [0, 0];
        for j in J do
            for k from 0 to orders[j] do
                deriv := diff(dummy_eqs[i], dummy[j][k+1]);
                if deriv <> 0 then
                    if testtype(deriv, Dom::Rational) then
                        Q[i, j] := Q[i, j] + deriv*s^k;
                        one_j := if one_j = 0 then j else -1 end_if;
                        one_k := k;
                    else
                        T[i, j] := s^k;  // no need to keep lower degree terms
                    end_if;
                end_if;
            end_for;
        end_for;
        
        // move a row of Q to T if it has only one monomial
        if one_j > 0 then
            Q[i, one_j] := 0;
            T[i, one_j] := s^(max(one_k, degree(T[i, one_j])));
        end_if;
    end_for;
    
    // apply the same separation to eqs
    Q_eqs := daepp::applyPolynomialMatrix(vars, vars, Q);
    for i from 1 to m do
        if linalg::nonZeros(linalg::row(T, i)) = 0 then
            Q_eqs[i] := eqs[i];
        end_if;
    end_for;
    T_eqs := simplify(eqs - Q_eqs);
    
    // remove unnecessary rows
    [Q_rows, T_rows] := map([Q, T], A -> if m > 0 then
            [select(i $ i = 1..m, i -> linalg::nonZeros(linalg::row(A, i)) > 0)]
        else
            []
        end_if
    );
    subm := (A, rows, cols) -> // linalg::submatrix does not work well if rows or cols are empty
        if nops(rows) = 0 then
            matrix(0, nops(cols))
        elif nops(cols) = 0 then
            matrix(nops(rows), 0)
        else
            linalg::submatrix(A, rows, cols)
        end_if;
    Q := subm(Q, Q_rows, [j $ j = 1..n]);
    T := subm(T, T_rows, [j $ j = 1..n]);
    Q_eqs := Q_eqs[Q_rows];
    T_eqs := T_eqs[T_rows];
    
    // connect corresponding rows
    [Qi, Ti] := [1, 1];
    ngList := indets(eqs, All);
    nint := nops(coerce(Q_rows, DOM_SET) intersect coerce(T_rows, DOM_SET));
    cnt := 0;
    gen_name := () -> "aux" . (if nint = 1 then "" else cnt := cnt + 1; expr2text(cnt) end_if);
    
    while Qi <= nops(Q_rows) and Ti <= nops(T_rows) do
        if Q_rows[Qi] = T_rows[Ti] then
            Q := Q . matrix(nops(Q_rows), 1, (i, j) -> if i = Qi then  1 else 0 end_if);
            T := T . matrix(nops(T_rows), 1, (i, j) -> if i = Ti then -1 else 0 end_if);
            newVar := daepp::generateVariable(NIL, 0, ngList, TimeVariable = tVar, Prefix = gen_name());
            ngList := ngList union indets(newVar, All);
            Q_eqs[Qi] := Q_eqs[Qi] + newVar;
            T_eqs[Ti] := T_eqs[Qi] - newVar;
            vars := vars . [newVar];
            Qi := Qi + 1;
            Ti := Ti + 1;
        elif Q_rows[Qi] < T_rows[Ti] then
            Qi := Qi + 1;
        else
            Ti := Ti + 1;
        end_if;
    end_while;
    
    // return
    [Q_eqs.T_eqs, vars, Q, T]
end_proc;
