// daepp -- the library for DAE preprocessing

daepp := newDomain("daepp");

daepp::Name := "daepp";
daepp::info := "Library for DAE preprocessing";

daepp::interface := {
    hold(checkInput),
    hold(hungarian),
    hold(orderMatrix),
    hold(systemJacobian),
    null()
};

autoload(daepp::checkInput);
autoload(daepp::hungarian);
autoload(daepp::orderMatrix);
autoload(daepp::systemJacobian);

// helper
autoload(daepp::toList);

null();
