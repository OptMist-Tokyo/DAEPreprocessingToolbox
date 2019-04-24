// MuPAD implementation for checkInput.m

daepp::checkInput := proc(eqs, vars)
begin
    // check number of arguments
    if args(0) <> 2 then
        error("List of equations and list of variables expected.");
    end_if;
    daetools::checkInput(eqs, vars, "AllowOnlyFuncVars");
end_proc;
