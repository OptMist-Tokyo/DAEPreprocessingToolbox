function df = diffByFunction(f, symfun)

% diffByFunction    Differentiate f by symfun(t).

validateattributes(f, {'sym'}, {'vector'}, mfilename, 'f', 1);
validateattributes(symfun, {'sym'}, {'scalar'}, mfilename, 'symfun', 2);

symvar = makeDummyVariable(symfun, f);
f = subs(f, symfun, symvar);
df = diff(f, symvar);
df = subs(df, symvar, symfun);
