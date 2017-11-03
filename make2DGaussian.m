%% function make2DGaussian

function template = make2DGaussian(N, sigma)
% N - number of elements
% sigma - standard deviation
    
    if N < 5 * sigma
        error('N must be at least 5 * sigma');
    end

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