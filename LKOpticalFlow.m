%% function LKOpticalFlow

function [u, v] = LKOpticalFlow(img1, img2, W)
% img1 - first image in sequence
% img2 - second image in sequence
% W - window size = 2W + 1

% Make Gaussian differential filters
G = make1DGaussian(6, 1);
G = -diff(G);
G_x = repmat(G, length(G), 1);
G_y = repmat(G', 1, length(G));

% Make Gaussian smoothing filter
G_s = make2DGaussian(5, 1);

% Smooth images
i1_s = filter2(G_s, img1);
i2_s = filter2(G_s, img2);

% Calculate temporal derivative
I_t = i2_s - i1_s;

% Calculate spatial derivative of img2
I_x = filter2(G_x, img2);
I_y = filter2(G_y, img2);

% Calculate products of derivatives
I_x_sq = I_x .* I_x;
I_y_sq = I_y .* I_y;
I_xy = I_x .* I_y;
I_xt = I_x .* I_t;
I_yt = I_y .* I_t;

% Preallocate u and v images
u = zeros(size(img1));
v = zeros(size(img1));

[rows, cols] = size(I_x);

for i = 1:rows
    for j = 1:cols
        
        r = max(1, i - W):min(rows, i + W);
        c = max(1, j - W):min(cols, j + W);
        
        A = [sum(sum(I_x_sq(r,c))), sum(sum(I_xy(r,c))); sum(sum(I_xy(r,c))), sum(sum(I_y_sq(r,c)))];
        b = -[sum(sum(I_xt(r,c))); sum(sum(I_yt(r,c)))];
        
        x = A \ b;
        
        u(i,j) = x(1);
        v(i,j) = x(2);
        
    end
end

end