function vars = makeDummyVariable(dx, F, varargin)

% Make dummy variables representing dx. The name of the dummy varaible is
% determined so that it does not appear in F.
%
% Parameters:
%     - Prefix : Prefix of the name of dummy variables.
%     - Output : Return symbolic functions if Output is set to 'symfun'.

validateattributes(dx, {'sym'}, {'vector'}, mfilename, 'dx', 1);
validateattributes(F, {'sym'}, {'vector'}, mfilename, 'F', 2);

% parse parameters
parser = inputParser;
addParameter(parser, 'Prefix', '', @isvarname);
addParameter(parser, 'Output', 'sym', @(x) any(validatestring(x, {'sym', 'symfun'})));
parser.parse(varargin{:});
options = parser.Results;

if isempty(dx)
    vars = zeros(1, 0, 'sym');
    return;
end

% extract the independent varaible t
c = children(dx);
if ~iscell(c)
    c = {c};
end
t = c{1};
t = t(end);

% convert symfun to sym
if isa(dx, 'symfun')
    dx = dx(t);
end
t = char(t);

% parse symfun and make the stem of new varaible names
n = length(dx);
stem = cell(0);
for j = 1:n
    tree = feval(symengine, 'prog::exprlist', dx(j));
    if strcmp(char(tree(1)), 'diff')
        order = length(tree) - 2;
        tmp = tree(2);
        stem{j} = ['D', char(tmp(1)), repmat(t, 1, order)];
    else
        stem{j} = char(tree(1));
    end
    stem{j} = [options.Prefix, stem{j}];
end

% collect used names
usednames = containers.Map('KeyType', 'char', 'ValueType', 'int8');
for i = 1:length(F)
    tree = feval(symengine, 'prog::exprlist', F(i));
    walk(tree);
end

% make the name unique in F
name = cell(0);
for j = 1:n
    k = 1;
    name{j} = stem{j};
    while isKey(usednames, name{j})
        name{j} = sprintf('%s%d', name{j}, k);
        k = k + 1;
    end
    usednames(name{j}) = 0;
end

% convert to symbolic variable or symbolic functions
if strcmp(options.Output, 'sym')
    vars = sym(name);
else
    vars = zeros(1, n, 'sym');
    for j = 1:n
        vars(j) = str2sym([name{j}, '(', t, ')']);
    end
end


% function for walking expression tree
function walk(node)
    op = char(node(1));
    usednames(op) = 0;
    
    for k = 2:length(node)
        walk(node(k))
    end
end

end
