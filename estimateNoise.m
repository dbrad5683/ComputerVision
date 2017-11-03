%% function estimateNoise

function noise_estimate = estimateNoise(flat_frames)
% flat_frames - 2D array with an image in each column
    
    % Find the mean pixel value and assume all values at or below that constitute noise
    mean_pixel = mean(flat_frames(:));
    noise_pixels = flat_frames(flat_frames <= mean_pixel);
    noise_estimate = std(noise_pixels);

end