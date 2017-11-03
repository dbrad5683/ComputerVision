%% function applyTemporalFilter

function [filtered_frames, noise_estimate] = applyTemporalFilter(frames, filter)
% frames - cell array of grayscale images
% template - row vector filter template

    N = length(frames);
    [rows, cols] = size(frames{1});

    % Flatten cell array into 2D array where each column is an image
    flat_frames = flattenFrames(frames);

    % Convolve with filter
    flat_filtered_frames = abs(conv2(1, filter, flat_frames, 'same'));
    
    % Estimate noise as average standard deviation of all derivative pixels <= median derivative pixel
    % noise_estimate = estimateNoise(flat_filtered_frames);
    noise_estimate = std(flat_filtered_frames(:));

    % Reconstruct
    filtered_frames = cell(N, 1);

    for i = 1:N
        filtered_frames{i,1} = reshape(flat_filtered_frames(:,i), rows, cols);
    end

end
