// Update relation table R using refR.

daepp::updateRelation := proc(R, refR)
local tableRefR, i, rh, var;
begin
    // check number of arguments
    if testargs() then
        if args(0) <> 2 then
            error("Two arguments expected.");
        end_if;
    end_if;
    
    // check input
    if testargs() then
        R := symobj::tolist(R);
        if not _and(type(r) = "_equal" $ r in R) then
            error("Equations expected for R.");
        end_if;
        if nops(lhs(R)) <> nops({op(lhs(R))}) then
            error("Duplicated variables in left hand sides of R.");
        end_if;
        
        refR := symobj::tolist(refR);
        if not _and(type(r) = "_equal" $ r in refR) then
            error("Equations expected for refR.");
        end_if;
        if nops(lhs(refR)) <> nops({op(lhs(refR))}) then
            error("Duplicated variables in left hand sides of refR.");
        end_if;
    end_if;
    
    tableRefR := table(refR);
    
    // update R
    for i from 1 to nops(R) do
        rh := rhs(R[i]);
        var := if type(rh) = "diff" then op(rh, 1) else rh end_if;
        if contains(tableRefR, var) then
            R[i] := lhs(R[i]) = (if type(rh) = "diff" then
                symobj::diff(tableRefR[var], op(rh, nops(rh)), nops(rh) - 1)
            else
                tableRefR[var]
            end_if);
        end_if;
    end_for;
    
    // return
    R;
end_proc;
