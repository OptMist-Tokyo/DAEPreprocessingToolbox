// Generate new dummy variable corresponding to the order-th order derivative
// of var.

daepp::generateVariable := proc(var, order, ngList)
local options, tVar, prefix, genfun, tTmp, newName, newVar;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 2 then
            error("At least two arguments expected.");
        end_if;
    end_if;
    
    // get options
    options := prog::getOptions(4, [args()], table(
        TimeVariable = NIL, Prefix = "", ReturnFunction = TRUE), TRUE)[1];
    tVar := options[TimeVariable];
    prefix := options[Prefix];
    genfun := options[ReturnFunction];
    
    // check input
    if testargs() then
        tTmp := daepp::checkDAEInput([], [var])[3];
        if not tVar in {NIL, tTmp} then
            error("Inconsistency of time variable.");
        end_if;
        if not testtype(order, Type::NonNegInt) then
            error("Second argument must be nonnegative integer.");
        end_if;
        if not testtype(ngList, DOM_SET) then
            error("Third argument must be a set.");
        end_if;
    end_if;
    
    // retrieve tVar
    if tVar = NIL then
        tVar := daepp::checkDAEInput([], [var])[3];
    end_if;
    
    // make new name
    newName := expr2text(op(var, 0));
    if order = 0 then
        newName := prefix . newName;
    else
        newName := prefix . "D" . newName . _concat(expr2text(tVar) $ order);
    end_if;
    
    // make new var
    newVar := DOM_IDENT(newName);
    if domtype(eval(newVar)) <> DOM_IDENT || showprop(newVar(tVar)) <> [] || showprop(newVar) <> [] || contains(ngList, newVar) then
        newVar := genident(newName);
    end_if;
    
    // add (tVar) if genfun = TRUE
    if genfun then
        newVar := newVar(tVar);
    end_if;
    
    // return
    newVar;
end_proc;
