%% function calculateFundamentalMatrix

function f = calculateFundamentalMatrix(points)
% points - Nx4 array [x1, y1, x2, y2]

    N = size(points, 1);
    A = zeros(N, 9);
    
    for i = 1:N
        
        % Convert from row, col to x, y
        x = points(i,2);
        y = points(i,1);
        xp = points(i,4);
        yp = points(i,3);
        
        A(i,:) = [x * xp, x * yp, x, y * xp, y * yp, y, xp, yp, 1];        
        
    end
    
    [~, ~, V] = svd(A);
    f = reshape(V(:,end), 3, 3)';
    
    [U_f, S_f, V_f] = svd(f);
    S_f(3,3) = 0;
    f = U_f * S_f * V_f';

end