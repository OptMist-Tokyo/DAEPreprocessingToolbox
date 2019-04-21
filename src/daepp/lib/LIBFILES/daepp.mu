// daepp -- the library for DAE preprocessing

daepp := newDomain("daepp");

daepp::Name := "daepp";
daepp::info := "Library for DAE preprocessing";

daepp::interface := {
    hold(checkInput),
    hold(findEliminatingSubsystem),
    hold(hungarian),
    hold(modifyBySubstitution),
    hold(orderMatrix),
    hold(systemJacobian),
    null()
};

autoload(daepp::checkInput);
autoload(daepp::findEliminatingSubsystem);
autoload(daepp::hungarian);
autoload(daepp::modifyBySubstitution);
autoload(daepp::orderMatrix);
autoload(daepp::systemJacobian);

null();
