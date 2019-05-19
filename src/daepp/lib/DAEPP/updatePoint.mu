// Update point using R.

daepp::updatePoint := proc(point, R)
local tablePoint, p, lh, rh, var, order, newPoint, r, pointKeys, duplicated;
begin
    // check number of arguments
    if testargs() then
        if args(0) <> 2 then
            error("Two arguments expected.");
        end_if;
    end_if;
    
    // check input
    if testargs() then
        point := daepp::checkPointInput(point);
        
        R := symobj::tolist(R);
        if not _and(type(r) = "_equal" $ r in R) then
            error("Equations expected for R.");
        end_if;
        if nops(lhs(R)) <> nops({op(lhs(R))}) then
            error("Duplicated variables in left hand sides of R.");
        end_if;
    end_if;
    
    // categorize point as variables
    tablePoint := table();
    for p in point do
        [lh, rh] := [lhs(p), rhs(p)];
        if type(lh) in {"function", "diff"} then
            [var, order] := if type(lh) = "diff" then [op(lh, 1), nops(lh) - 1] else [lh, 0] end_if;
            if contains(tablePoint, var) then
                tablePoint[var][order] := rh;
            else
                tablePoint[var] := table(order = rh);
            end_if;
        end_if;
    end_for;
    
    // update point
    newPoint := [];
    for r in R do
        [lh, rh] := [lhs(r), rhs(r)];
        [var, order] := if type(rh) = "diff" then [op(rh, 1), nops(rh) - 1] else [rh, 0] end_if;
        if contains(tablePoint, var) then
            if type(lh) in {"function", "diff"} then
                newPoint := newPoint . [symobj::diff(lh, op(lh), lhs(p) - order) = rhs(p)
                    $ p in select(tablePoint[var], p -> lhs(p) >= order)];
            elif contains(tablePoint[var], order) then
                newPoint := append(newPoint, lh = tablePoint[var][order]);
            end_if;
        end_if;
    end_for;
    
    // check duplication
    pointKeys := {op(lhs(point))};
    duplicated := select(newPoint, p -> lhs(p) in pointKeys);
    if nops(duplicated) > 0 then
        warning("The symbol(s) " . expr2text(v $ v in lhs(duplicated))
            . " already exist in poinKeys. Their values are updated.");
        (point[contains(lhs(point), lhs(p))] := p) $ p in duplicated;
    end_if;
    
    point := point . select(newPoint, p -> not lhs(p) in pointKeys);
    
    // return
    point;
end_proc;
