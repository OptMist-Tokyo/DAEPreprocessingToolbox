function df = diffByFunction(f, symfun)

% Differentiate f by symfun(t). This function does not work well if symfun is
% not differentiated but F has derivatives of symfun.

validateattributes(f, {'sym'}, {'vector'}, mfilename, 'f', 1);
validateattributes(symfun, {'sym'}, {'scalar'}, mfilename, 'symfun', 2);

symvar = makeDummyVariable(symfun, f);
f = subs(f, symfun, symvar);
df = diff(f, symvar);
df = subs(df, symvar, symfun);
