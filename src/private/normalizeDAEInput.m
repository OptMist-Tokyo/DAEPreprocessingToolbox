function [F, x, t] = normalizeDAEInput(F, x)

% check arguments
validateattributes(F, {'sym'}, {'vector'}, mfilename, 'F', 1);
validateattributes(x, {'sym'}, {'vector'}, mfilename, 'x', 2);

% check F
assert(~isa(F, 'symfun'), 'F must not be a symbolic function. Maybe forgetting (t).');

% move RHS to LHS
for i = 1:length(F)
    op = char(feval(symengine, 'op', F(i), 0));
    if strcmp(op, '_SYM_equal')
        F(i) = lhs(F(i)) - rhs(F(i));
    end
end

% escape if x is empty
if isempty(x)
    t = sym('t');
    return;
end

% extract the independent varaible t
c = children(x);
if ~iscell(c)
    c = {c};
end
t = c{1};

% check t
assert(length(t) == 1, 'Input x is invalid.');
for k = 2:length(c)
    assert(isequal(c{k}, t), 'Input x is invalid.');
end

% normalize x = [x1, ..., xn] (type symfun) to [x1(t), ..., xn(t)] (type sym)
if isa(x, 'symfun')
    x = x(t);
end

% check x
n = length(x);
for j = 1:n
    tree = feval(symengine, 'prog::exprlist', x(j));
    assert(length(tree) == 2 && isequal(tree(2), t), 'Input x is invalid.');
end

assert(length(unique(arrayfun(@char, x, 'UniformOutput', false))) == n, 'Input x contains the same variables.');
