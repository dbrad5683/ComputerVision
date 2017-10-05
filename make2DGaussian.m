%% function make2DGaussian

function template = make2DGaussian(sigma)
% sigma - standard deviation

    N = ceil(5 * sigma);
    
    if mod(N, 2) == 0
        N = N + 1;
    end
    
    % Generate co-ordinates
    ind = -floor(N / 2) : floor(N / 2);
    [X, Y] = meshgrid(ind, ind);

    % Create 2D Gaussian filter
    template = exp(-(X.^2 + Y.^2) / (2 * sigma * sigma));

    % Normalize
    template = template / sum(template(:));

end