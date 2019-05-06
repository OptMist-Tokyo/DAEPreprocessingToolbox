// MuPAD implementation for extractVariableValue.m

daepp::extractVariableValue := proc(vars, point)
local tVar, tTmp, varsp, missing, msg, y, yp;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 2 then
            error("At lest two arguments expected.");
        end_if;
    end_if;
    
    // convert to lists and retrieve tVar
    vars := symobj::tolist(vars);
    
    // get options
    options := prog::getOptions(3, [args()], table(
        TimeVariable = NIL,
        MissingVariables = "warning"
    ), TRUE)[1];
    tVar := options[TimeVariable];
    
    // check input
    if testargs() then
        [vars, tTmp] := daepp::checkDAEInput([], vars)[[2, 3]];
        if not tVar in {NIL, tTmp} then
            error("Inconsistency of time variable.");
        end_if;
        point := daepp::checkPointInput(point);
    end_if;
    
    // convert point to table
    point := table(point);
    
    // retrieve tVar and differentiate vars
    if tVar = NIL then
        tVar := daepp::checkDAEInput(eqs, vars)[3];
    end_if;
    varsp := [diff(var, tVar) $ var in vars];
    
    // check if point contains all vars and its derivaitves
    missing := select(vars . varsp, var -> not contains(point, var));
    if nops(missing) <> 0 then
        msg := "Point values of the following variables are missing: " . expr2text(var $ var in missing);
        case options[MissingVariables]
            of "error" do error(msg); break;
            of "warning" do warning(msg . ". Their values are assumed to be zero."); break;
        end_case;
        
        // set missing variables to be 0
        (point[var] := 0) $ var in missing;
    end_if;
    
    // get y and yp
    y := [point[var] $ var in vars];
    yp := [point[var] $ var in varsp];
    
    [y, yp];
end_proc;
