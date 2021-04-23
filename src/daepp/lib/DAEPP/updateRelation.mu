// Update relation table R using refR.

daepp::updateRelation := proc(R, refR)
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
    
    // update R
    simplify(rewrite(subs(R, table(refR)), diff))
end_proc;
