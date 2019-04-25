// Check whether values is in the form
// [y(t) = 0.5, diff(y(t), t) = 0.2, g = 0.8, ...]

daepp::checkValuesInput := proc(values)
local L, R, isValidFunc, tVar;
begin
    // check number of arguments
    if args(0) <> 1 then
        error("One argument expected.");
    end_if;
    
    // convert to list
    values := symobj::tolist(values);
    
    // format check
    if not _and(type(v) = "_equal" $ v in values) then
        error("Equations expected.");
    end_if;
    
    L := map(values, lhs);
    R := map(values, rhs);
    
    if nops(L) <> nops({op(L)}) then
        error("Duplicated variables in left hand sides.");
    end_if;
    
    isValidFunc := f ->
        type(f) = "function" &&
        type(op(f, 0)) in {DOM_IDENT, "index"} &&
        nops(f) = 1 &&
        type(op(f, 1)) = DOM_IDENT &&
        freeIndets(f) <> {};
    
    if not _and((
        type(l) in {DOM_IDENT, "_index"} ||
        isValidFunc(l) ||
        (type(l) = "diff" && isValidFunc(op(l)))
    ) $ l in L) then
        error("Invalid right hand side.");
    end_if;
    
    if not _and(testtype(r, Dom::Real) $ r in R) then
        error("Real values expected in right hand sides.");
    end_if;
    
    // check the consistency of time variables
    tVar := {op(l, nops(l)) $ l in select(L, l -> testtype(l, "function"))};
    if nops(tVar) > 1 then
        error("Multiple time variables are not allowed."); 
    end_if;
    
    // return
    zip(L, R, (l, r) -> l = float(r));
end_proc;
