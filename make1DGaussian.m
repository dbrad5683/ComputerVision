%% function make1DGaussian

function template = make1DGaussian(N, sigma)
% N - number of elements
% sigma - standard deviation

    if N < 5 * sigma
        error('N must be at least 5 * sigma');
    end
    
    % Generate co-ordinates
    X = linspace(-floor(N / 2), floor(N / 2), N);

    % Create 2D Gaussian filter
    template = exp(-X.^2 / (2 * sigma * sigma));

    % Normalize
    template = template / sum(template(:));

end