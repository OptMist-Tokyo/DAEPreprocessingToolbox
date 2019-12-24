/*
  Apply a polynomial matrix to DAEs. (s == derivative)
*/

daepp::applyPolynomialMatrix := proc(eqs, vars, P /*, tVar */)
local N, m, s, tVar, apply;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 3 || 4 < args(0) then
            error("Three or four arguments expected.");
        end_if;
    end_if;
    
    // convert to lists
    [eqs, vars] := map([eqs, vars], symobj::tolist);
    
    // convert to a matrix
    P := symobj::tomatrix(P);
    [N, m] := linalg::matdim(P);
    
    // check input
    if testargs() then
        [eqs, vars, tVar] := daepp::checkDAEInput(eqs, vars);
        if args(0) = 4 && tVar <> args(4) then
            error("Inconsistency of time variable.");
        end_if;
        
        if nops(eqs) <> m then
            error("Inconsistency between the size of eqs and the dimension of P.");
        end_if;
        
        if nops(indets(P)) > 1 then
            error("P cannot have two or more indeterminates.");
        end_if;
        
        s := if nops(indets(P)) = 1 then indets(P)[1] else genident("s") end_if;
        if _or(poly(p, [s], Dom::Rational) = FAIL $ p in P) then
            error("The entries in P must be an univariate polynomial over rationals.");
        end_if;
    end_if;
    
    // retrieve tVar
    if args(0) = 3 then
        [eqs, vars, tVar] := daepp::checkDAEInput(eqs, vars);
    else
        tVar := args(4);
    end_if;
    
    // function that converts eqs(i) according to a polynomial p
    apply := (i, p) -> lcoeff(p) * symobj::diff(eqs[i], tVar, degree(p));
    
    // return
    [collect(_plus(_plus(apply(i, p) $ p in monomials(P[ii, i])) $ i = 1..m), vars) $ ii = 1..N];
end_proc;
