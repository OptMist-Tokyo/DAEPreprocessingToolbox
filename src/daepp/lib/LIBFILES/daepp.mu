// daepp -- the library for DAE preprocessing

daepp := newDomain("daepp");

daepp::Name := "daepp";
daepp::info := "Library for DAE preprocessing";

daepp::interface := {
    hold(addEntry),
    hold(applyPolynomialMatrix),
    hold(checkDAEInput),
    hold(checkPointInput),
    hold(convertToLayeredMixed),
    hold(daeJacobianFunction),
    hold(extractVariableValue),
    hold(findEliminatingSubsystem),
    hold(gaussJordan),
    hold(generateVariable),
    hold(greedyPivoting),
    hold(isLowIndex),
    hold(hungarian),
    hold(modifyByAugmentation),
    hold(modifyBySubstitution),
    hold(orderMatrix),
    hold(preprocessDAE),
    hold(reduceIndex),
    hold(substitutePoint),
    hold(systemJacobian),
    hold(updatePoint),
    hold(updateRelation),
    null()
};

autoload(daepp::addEntry);
autoload(daepp::applyPolynomialMatrix);
autoload(daepp::checkDAEInput);
autoload(daepp::checkPointInput);
autoload(daepp::convertToLayeredMixed);
autoload(daepp::daeJacobianFunction);
autoload(daepp::extractVariableValue);
autoload(daepp::findEliminatingSubsystem);
autoload(daepp::gaussJordan);
autoload(daepp::generateVariable);
autoload(daepp::greedyPivoting);
autoload(daepp::hungarian);
autoload(daepp::isLowIndex);
autoload(daepp::modifyByAugmentation);
autoload(daepp::modifyBySubstitution);
autoload(daepp::orderMatrix);
autoload(daepp::preprocessDAE);
autoload(daepp::reduceIndex);
autoload(daepp::substitutePoint);
autoload(daepp::systemJacobian);
autoload(daepp::updatePoint);
autoload(daepp::updateRelation);

null();
