%% function applyTemporalFilter

function [filtered_frames, noise] = applyTemporalFilter(frames, template)
% frames - cell array of grayscale images
% template - row vector filter template

    N = length(frames);
    [rows, cols] = size(frames{1});
    
    % Calculate padding
    pad = floor(length(template) / 2);

    flat_frames = flattenFrames(frames, pad);

    % Convolve with mask and trim padding
    flat_filtered_frames = abs(conv2(1, template, flat_frames, 'same'));
    flat_filtered_frames = flat_filtered_frames(:,(1:N) + pad);
    
    % Estimate noise as average standard deviation of all pixels
    noise = estimateNoise(flat_filtered_frames);

    % Reconstruct
    filtered_frames = cell(N, 1);

    for i = 1:N
        filtered_frames{i,1} = reshape(flat_filtered_frames(:,i), rows, cols);
    end

end
