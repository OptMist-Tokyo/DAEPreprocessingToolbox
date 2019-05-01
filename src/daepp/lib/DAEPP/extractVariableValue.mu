// MuPAD implementation for extractVariableValue.m

daepp::extractVariableValue := proc(vars, point /*, tVar */)
local tVar, varsp, missing, y, yp;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 2 || 3 < args(0) then
            error("Two or three arguments expected.");
        end_if;
    end_if;
    
    // convert to lists and retrieve tVar
    vars := symobj::tolist(vars);
    
    // check input
    if testargs() then
        [vars, tVar] := daepp::checkDAEInput([], vars)[[2, 3]];
        if args(0) = 3 && tVar <> args(3) then
            error("Inconsistency of time variable.");
        end_if;
        point := daepp::checkPointInput(point);
    end_if;
    
    // convert point to table
    point := table(point);
    
    // retrieve tVar and differentiate vars
    if args(0) = 2 then
        [vars, tVar] := daepp::checkDAEInput([], vars)[[2, 3]];
    else
        tVar := args(3);
    end_if;
    varsp := [diff(var, tVar) $ var in vars];
    
    // check if point contains all vars and its derivaitves
    missing := select(vars . varsp, var -> not contains(point, var));
    if nops(missing) <> 0 then
        error("Point values of the following variables are missing: " . expr2text(var $ var in missing));
    end_if;
    
    // get y and yp
    y := [point[var] $ var in vars];
    yp := [point[var] $ var in varsp];
    
    [y, yp];
end_proc;
