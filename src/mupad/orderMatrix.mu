/*
  Return a matrix whose (i, j)-th entry contains the maximum k such that eqs[i]
  depends on the k-th order derivative of vars[j]. If eqs[i] does not depend on
  any derivative of vars[j], the entry is set to -Inf.
*/

orderMatrix := proc(eqs, vars)
local m, n, t, sub;
begin
    // check input
    if args(0) <> 2 then
        error("List of equations and list of variables expected.");
    end_if;
    [eqs, vars, t] := daetools::checkInput(eqs, vars, "AllowOnlyFuncVars");
    [m, n] := [nops(eqs), nops(vars)];
    
    // extract subexpressions with 'diff' operator
    sub := map(eqs, eq -> misc::subExpressions(eq, "diff"));

    return(matrix(m, n, proc(i, j)
        local orders;
        begin
            orders := map(select(sub[i], v -> op(v, 1) = vars[j]), v -> nops(v) - 1);
            if nops(orders) > 0 then
                max(orders);
            else
                if has(eqs[i], vars[j]) then 0 else -infinity end_if;
            end_if;
        end_proc)
    );
end_proc;
