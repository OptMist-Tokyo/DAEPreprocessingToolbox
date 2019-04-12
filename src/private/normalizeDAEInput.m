function [F, x, t] = normalizeDAEInput(F, x)

% check arguments
validateattributes(F, {'sym'}, {'vector'}, mfilename, 'F', 1);
validateattributes(x, {'sym'}, {'vector'}, mfilename, 'x', 2);

% escape if x is empty
if isempty(x)
    t = sym('t');
    return
end

% extract the independent varaible t
c = children(x);
if iscell(c)
    t = c{1};
else
    t = c;
end

% normalize x = [x1, ..., xn] (type symfun) to [x1(t), ..., xn(t)] (type sym)
if isa(x, 'symfun')
    x = x(t);
end
