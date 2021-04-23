// Substitute point for f.

daepp::substitutePoint := proc(f, point)
local value, diffs, dummy1, funcNames, funcs, dummy2, vars, missing;
begin
    // check input
    if testargs() then
        if args(0) <> 2 then
            error("Two arguments expected.");
        end_if;
        point := daepp::checkPointInput(point);
    end_if;
    
    // substitute
    value := float(subs(f, point));
    
    // check if value has no symbols
    if not _and(testtype(v, Type::Real) $ v in value) then
        
        // obtain differentiations and replace by indeterminates
        diffs := misc::subExpressions(value, "diff");
        dummy1 := [genident() $ d in diffs];
        value := subs(value, [diffs[i] = dummy1[i] $ i = 1..nops(diffs)]);
        
        // obtain non-differentiated function symbols and replace by indeterminates
        funcNames := select(indets(value, All), v -> protected(v) = None) minus freeIndets(value);
        funcs := {};
        misc::maprec(value, (e -> is(op(e, 0) in funcNames)) = (e -> (funcs := funcs union {e}; e)));
        dummy2 := [genident() $ fn in funcs];
        value := subs(value, [funcs[i] = dummy2[i] $ i = 1..nops(funcs)]);
        
        // obtain constant symbols
        vars := freeIndets(value) minus coerce(dummy1 . dummy2, DOM_SET);
        
        // print error
        missing := _union(vars, funcs, diffs);
        error("Point values of the following symbols are missing: " . expr2text(var $ var in missing));
    end_if;
    
    // return
    float(value);
end_proc;
