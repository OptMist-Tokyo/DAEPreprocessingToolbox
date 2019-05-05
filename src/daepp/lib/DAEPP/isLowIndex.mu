// MuPAD implementation for isLowIndex.m

daepp::isLowIndex := proc(eqs, vars /* , tVar */)
local tVar;
begin
    // check number of arguments
    if args(0) < 2 || 3 < args(0) then
        error("Two or three arguments expected.");
    end_if;
    
    // convert to lists
    [eqs, vars] := map([eqs, vars], symobj::tolist);
    
    // check input
    if testargs() then
        [eqs, vars, tVar] := daepp::checkDAEInput(eqs, vars);
        if args(0) = 3 && tVar <> args(3) then
            error("Inconsistency of time variable.");
        end_if;
        if nops(eqs) <> nops(vars) then
            error("Inconcistency of sizes between equations and variables.")
        end_if;
    end_if;
    
    // retrieve tVar
    if args(0) = 2 then
        [eqs, vars, tVar] := daepp::checkDAEInput(eqs, vars);
    else
        tVar := args(3);
    end_if;
    
    // call functions in daetools
    [eqs, vars] := daetools::reduceDifferentialOrder(eqs, vars, TimeVariable = tVar)[[1, 2]];
    daetools::isLowIndexDAE(eqs, vars, TimeVariable = tVar);
end_proc;
