%% function harrisCornerDetector

function C = harrisCornerDetector(img)
% img - image
% threshold - R threshold

    % Make Gaussian differential filters
    G = make1DGaussian(6, 1);
    G = -diff(G);
    G_x = repmat(G, length(G), 1);
    G_y = repmat(G', 1, length(G));

    % Make Gaussian smoothing filter
    G_s = make2DGaussian(5, 1);

    % Calculate image derivatives
    I_x = filter2(G_x, img);
    I_y = filter2(G_y, img);

    % Calculate products of derivatives
    I_x_sq = I_x .* I_x;
    I_y_sq = I_y .* I_y;
    I_xy = I_x .* I_y;

    % Smooth products of derivatives
    S_x = filter2(G_s, I_x_sq);
    S_y = filter2(G_s, I_y_sq);
    S_xy = filter2(G_s, I_xy);

    % Calculate M matrix and R value for each pixel
    M = cell(size(img));
    C = zeros(size(img));

    for i = 1:size(img, 1)
        for j = 1:size(img, 2)

            M{i,j} = [S_x(i,j), S_xy(i,j); S_xy(i,j), S_y(i,j)];
            C(i,j) = det(M{i,j}) - (0.05 * trace(M{i,j})^2);

            if C(i,j) < 10000
                C(i,j) = 0;
            end

        end
    end
    
    % Find corners
    [r, c] = find(C > 0);
    
    % Supress any corners on the edges of the image
    C(r(r == 1), :) = 0;
    C(r(r == size(img,1)), :) = 0;
    C(:, c(c == 1)) = 0;
    C(:, c(c == size(img,2))) = 0;
    
    % Re-find corners
    [r, c] = find(C > 0);
    
    % Perform non-max suppression in 2D around the corners
    for i = 1:length(r)
        
        u = r(i);
        v = c(i);
        
        w = C((u - 1):(u + 1),(v - 1):(v + 1));
        
        while C(u,v) < max(w(:))
            
            C(u,v) = 0;
            [dr,dv] = find(w == max(w(:)));
            u = u + dr - 2;
            v = v + dv - 2;
            w = C((u - 1):(u + 1),(v - 1):(v + 1));
            
        end
        
    end

end