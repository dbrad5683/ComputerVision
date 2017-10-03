function [row, col] = separateFilter(template)
    
    [U, S, V] = svd(template);
    
    row = abs(V(:,1)' * sqrt(S(1,1)));
    col = abs(U(:,1) * sqrt(S(1,1)));

end