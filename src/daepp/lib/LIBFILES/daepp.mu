// daepp -- the library for DAE preprocessing

daepp := newDomain("daepp");

daepp::Name := "daepp";
daepp::info := "Library for DAE preprocessing";

daepp::interface := {
    hold(checkDAEInput),
    hold(checkPointInput),
    hold(daeJacobianFunction),
    hold(extractVariableValue),
    hold(findEliminatingSubsystem),
    hold(gaussJordan),
    hold(greedyPivoting),
    hold(hungarian),
    hold(modifyByAugmentation),
    hold(modifyBySubstitution),
    hold(orderMatrix),
    hold(preprocessDAE),
    hold(substitutePoint),
    hold(systemJacobian),
    null()
};

autoload(daepp::checkDAEInput);
autoload(daepp::checkPointInput);
autoload(daepp::daeJacobianFunction);
autoload(daepp::extractVariableValue);
autoload(daepp::findEliminatingSubsystem);
autoload(daepp::gaussJordan);
autoload(daepp::greedyPivoting);
autoload(daepp::hungarian);
autoload(daepp::modifyByAugmentation);
autoload(daepp::modifyBySubstitution);
autoload(daepp::orderMatrix);
autoload(daepp::preprocessDAE);
autoload(daepp::substitutePoint);
autoload(daepp::systemJacobian);

null();
