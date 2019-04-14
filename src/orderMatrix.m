function S = orderMatrix(F, x)

% orderMatrix    Matrix storing differential orders of variables in DAE system.
%
%   Return a matrix whose (i, j)-th entry contains the maximum k such that F_i
%   depends on the k-th order derivative of x_j(t). If F_i does not depend on
%   any derivative of x_j(t), the entry is set to -Inf. The output is intended
%   to be passed to the "hungarian" function.
%
%   See Also: hungarian

[F, x, t] = normalizeDAEInput(F, x);

m = length(F);
n = length(x);
S = -Inf(m, n);

% convert to chars
varnames = arrayfun(@char, x, 'UniformOutput', false);
prefix = ['(', char(t), ')'];

for i = 1:m
    tree = feval(symengine, 'prog::exprlist', F(i));
    walk(tree, 0);
end


% walk expression tree
function walk(node, order)
    l = length(node);
    op = char(node(1));
    
    if strcmp(op, 'diff')
        order = l - 2;
    else
        j = find(strcmp(varnames, strcat(op, prefix)), 1);
        if ~isempty(j)
            S(i, j) = max(S(i, j), order);
        end
    end
    
    for k = 2:l
        walk(node(k), order)
    end
end

end
