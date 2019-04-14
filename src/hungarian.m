function [optval, s, t, p, q] = hungarian(M)

% hungarian    The hungarian method for assignment problem.
%
%   Compute a maximum assignment for an n x n cost matrix M by the Hungarian
%   method.
%   Also return an optimal solution (p1, ..., pn, q1, ..., qn) of the
%   following dual problem:
%
%       minimize    (q_1 + ... + q_n) - (p_1 + ... + p_n)
%       subject to  q_j - p_i >= M(i, j)                    (1 <= i, j <= n)
%                   q_j and p_i are nonnegative integers    (1 <= i, j <= n)
%
%   Return Values:
%       - optval : the optimal value. If M has no perfect matching, this is
%                  set to -Inf.
%       -      s : the i-th row is assigned to the s(i)-th column
%       -      t : the j-th column is assigned to the t(j)-th row
%                  (t is the inverse of s as a permutation)
%       -      p : optimal dual solution in rows
%       -      q : optimal dual solution in columns
%
%   See Also: orderMatrix, systemJacobian

validateattributes(M, {'numeric'}, {'2d', 'square', 'nonnan', 'real'}, mfilename, 'M');
assert(isinteger(M) || all(all(M ~= Inf(class(M)))), 'Expected M not to contain Inf.');

[n, ~] = size(M);

% initialize variables
optval = -Inf;
s = -ones(n, 1);
t = -ones(1, n);
p = zeros(n, 1, class(M));
q = max(M);
if any(isinf(q))
    return;
end

if isinteger(M)
    maxval = intmax(class(M));
else
    maxval = Inf;
end

% r is the root of an augmenting tree
for r = 1:n
    assert(s(r) == -1);
    
    slack = repmat(maxval, 1, n);
    slackid = -ones(1, n);
    
    updateSlack(r);
    
    % prev[j] := parent of j in the DFS tree (-1 means j does not belong to the tree)
    prev = -ones(1, n);
    
    j = findAugmentingPath;
    if j == -1
        return;
    end
    
    % augment the matching
    while j ~= -1
        assert(prev(j) ~= -1);
        next = s(prev(j));
        t(j) = prev(j);
        s(prev(j)) = j;
        j = next;
    end
end

% compute the optimal value
optval = zeros(class(M));
for i = 1:n
    for j = 1:n
        if s(i) == j
            optval = optval + M(i, j);
            break;
        end
    end
end


% subroutine for update of slack
function updateSlack(i)
    for j = 1:n
        newslack = q(j) - p(i) - M(i, j);
        if newslack < slack(j)
            slack(j) = newslack;
            slackid(j) = i;
        end
    end
end

% subroutine for augmentation
function j = findAugmentingPath()
    Q = r;
    head = 1;
    
    while true
        % construct the augmenting tree by BFS
        while head <= length(Q)
            i = Q(head);
            head = head + 1;
            for j = 1:n
                if prev(j) == -1 && q(j) - p(i) == M(i, j)
                    prev(j) = i;
                    if t(j) == -1
                        return; % found an augmenting path!
                    end
                    updateSlack(t(j));
                    Q = [Q t(j)];
                end
            end
        end
        
        % update potentials
        delta = min(slack(prev == -1));
        if delta == maxval
            j = -1;
            return; % no augmenting math
        end
        
        for i = Q
            p(i) = p(i) + delta;
        end
        
        for j = 1:n
            if prev(j) ~= -1
                q(j) = q(j) + delta;
            else
                slack(j) = slack(j) - delta;
            end
        end
        
        % add vertices to the tree as a result of improving the potentials
        for j = 1:n
            if prev(j) == -1 && slack(j) == 0
                assert(slackid(j) ~= -1);
                prev(j) = slackid(j);
                if t(j) == -1
                    return; % found an augmenting path!
                end
                updateSlack(t(j));
                Q = [Q t(j)];
            end
        end
    end
end

end
