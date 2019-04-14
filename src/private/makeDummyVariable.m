function symvar = makeDummyVariable(symfun, F)

% Make a dummy symbolic variable representing symfun. The name of the dummy
% varaible is determined so that it does not appear in F.

% parse symfun and make the stem of new varaible name
tree = feval(symengine, 'prog::exprlist', symfun);
if strcmp(char(tree(1)), 'diff')
    tmp = tree(2);
    stem = ['D', char(tmp(1)), repmat(char(tree(end)), 1, length(tree) - 2)];
else
    stem = char(tree(1));
end

% collect used names
usednames = containers.Map('KeyType', 'char', 'ValueType', 'int8');
for i = 1:length(F)
    tree = feval(symengine, 'prog::exprlist', F(i));
    walk(tree);
end

% make unique
k = 1;
name = stem;
while isKey(usednames, name)
    name = sprintf('%s%d', name, k);
    k = k + 1;
end

% convert to symbolic variable
symvar = sym(name);


% function for walking expression tree
function walk(node)
    op = char(node(1));
    usednames(op) = 0;
    
    for k = 2:length(node)
        walk(node(k))
    end
end

end