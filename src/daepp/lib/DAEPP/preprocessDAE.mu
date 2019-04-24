// MuPAD implementation for preprocessDAE.m

daepp::preprocessDAE := proc(eqs, vars /*, tVar */)
local tVar, hast, oparg, options, value, consts, S, v, ss, tt, p, q, D, r, II, JJ, newConsts;
begin
    // check number of arguments
    if testargs() then
        if args(0) < 2 then
            error("List of equations and list of variables expected.");
        end_if;
    end_if;
    
    // convert to lists
    [eqs, vars] := map([eqs, vars], symobj::tolist);
    
    // get options
    hast := is(args(0) > 2 && not testtype(args(3), table));
    oparg := if hast then 4 else 3 end_if;
    options := prog::getOptions(oparg, [args()], table(
        Method = "augmentation",
        Constants = "sym"
    ), TRUE)[1];
    
    // check input
    if testargs() then
        [eqs, vars, tVar] := daetools::checkInput(eqs, vars, "AllowOnlyFuncVars");
        if hast && tVar <> args(oparg - 1) then
            error("Inconsistency of time variable.");
        end_if;
    end_if;
    
    // retrive tVar
    if not hast then
        [eqs, vars, tVar] := daepp::checkInput(eqs, vars);
    else
        tVar := args(oparg - 1);
    end_if;
    
    value := infinity;
    consts := [];
    
    // main loop
    while TRUE do
        // Phase 1: Solve Assignment Problem
        S := daepp::orderMatrix(eqs, vars);
        [v, ss, tt, p, q] := daepp::hungarian(S);
        
        if v = -infinity then
            error("Order matrix of DAE has no perfect matching.");
        end_if;
        if value <= v then
            error("The optimal value of the assignment problem does not decrease.");
        end_if;
        value := v;
        
        // Phase 2: Check the Nonsingularity of System Jacobian
        D := daepp::systemJacobian(eqs, vars, p, q, tVar);
        [r, II, JJ] := daepp::findEliminatingSubsystem(D, p);
        if r = 0 then
            break;
        end_if;
        
        
        // Phase 3: Modify DAE
        case options[Method]
            of "substitution" do 
                eqs := daepp::modifyBySubstitution(eqs, vars, p, q, r, II, JJ, tVar);
                break;
            of "augmentation" do
                case options[Constants]
                    of "sym" do
                        [eqs, vars, newConsts]
                            := daepp::modifyByAugmentation(eqs, vars, p, q, r, II, JJ, tVar, Constants = "sym");
                        consts := consts . newConsts;
                        break;
                    of "zero" do
                        [eqs, vars]
                            := daepp::modifyByAugmentation(eqs, vars, p, q, r, II, JJ, tVar, Constants = "zero"); 
                        break;
                    otherwise
                        error("Invalid parameter of 'Constants'.");
                end_case;
                break;
            otherwise
                error("Invalid parameter of 'Method'.");
        end_case;
    end_while;
    
    // return
    case options[Constants]
        of "sym" do [eqs, vars, value, consts]; break;
        of "zero" do [eqs, vars, value]; break;
        otherwise error("Invalid parameter of 'Constants'.");
    end_case;
end_proc;
