orderMatrix := proc(eqs, vars)
local m, n, t, sub;
begin
    // check input
    if args(0) <> 2 then
        error(message("symbolic:daetools:ExpectingListsOfEqsAndVars"));
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
end_proc:
