function df = diffByFunction(f, dx)

% Differentiate f by dx(t). This function does not work well if dx is not
% differentiated but F has derivatives of dx.

validateattributes(f, {'sym'}, {'vector'}, mfilename, 'f', 1);
validateattributes(dx, {'sym'}, {'vector'}, mfilename, 'dx', 2);

vars = makeDummyVariable(dx, f);
f = subs(f, dx, vars);
df = jacobian(f, vars);
df = subs(df, vars, dx);
