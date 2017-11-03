%% function calculateHomography

function h = calculateHomography(points)
% points - Nx4 array [x1, y1, x2, y2]

    N = size(points, 1);
    A = zeros(2 * N, 9);
    
    for i = 1:N
        
        % Convert from row, col to x, y
        x = points(i,2);
        y = points(i,1);
        xp = points(i,4);
        yp = points(i,3);
        
        idx = (2 * i) - 1;
        A(idx,:) = [x, y, 1, 0, 0, 0, -x * xp, -y * xp, -xp];
        A(idx + 1,:) = [0, 0, 0, x, y, 1, -x * yp, -y * yp, -yp];
        
    end
    
    [U, S, ~] = svd(A' * A);
    [~, minI] = min(diag(S));
    h = reshape(U(:,minI), 3, 3)';

end