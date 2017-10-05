%% function estimateNoise

function average_noise = estimateNoise(flat_frames)
% flat_frames - 2D array with an image in each column

    N = size(flat_frames, 2);
    mean_pixels = repmat(mean(flat_frames, 2), 1, N);
    zero_mean_pixels = flat_frames - mean_pixels;
    noise_pixels = sqrt(sum(zero_mean_pixels.^2, 2) ./ (N - 1));
    average_noise = mean(noise_pixels);

end