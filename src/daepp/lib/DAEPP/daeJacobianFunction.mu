// MuPAD implementation for daeJacobianFunction.m

daepp::daeJacobianFunction := proc(eqs, vars /*, tVar */)
local tVar, S, n, YP, Y, J, JP;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 2 || 3 < args(0) then
            error("Two or three arguments expected.");
        end_if;
    end_if;
    
    // convert to lists and retrive tVar
    [eqs, vars] := map([eqs, vars], symobj::tolist);
    
    // check input
    if testargs() then
        [eqs, vars, tVar] := daetools::checkInput(eqs, vars, "AllowOnlyFuncVars");
        S := daepp::orderMatrix(eqs, vars);
        if not _and(v <= 1 $ v in S) then
            error("DAE has higher order derivatives.");
        end_if;
    end_if;

    // retrive tVar
    if args(0) = 2 then
        [eqs, vars, tVar] := daepp::checkInput(eqs, vars);
    else
        tVar := args(3);
    end_if;
    
    // change symbolic functions to variables
    n := nops(vars);
    YP := [genident("YP") $ j = 1..n];
    eqs := subs(eqs, [diff(vars[j], tVar) = YP[j] $ j = 1..n]);
    Y := [genident("Y") $ j = 1..n];
    eqs := subs(eqs, [vars[j] = Y[j] $ j = 1..n]);
    
    // get jacobians
    J := jacobian(eqs, Y);
    JP := jacobian(eqs, YP);
    
    [J, JP, Y, YP];
end_proc;
