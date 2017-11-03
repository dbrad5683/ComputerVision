%% Function motionDetector

function masked_frames = motionDetector(frames, temporal_filter, spatial_filter)
% frames          : cell array where each cell contains an image frame
% temporal_filter : 1D filter to be applied in the temporal domain
% spatial_filter  : 2D filter to be applied in the spatial domain

    N = length(frames);

    % Apply spatial filter
    fprintf('Applying spatial filter...\n');
    spatial_filtered_frames = cell(N, 1);

    if spatial_filter == 1
        spatial_filtered_frames = frames;
    else
        for i = 1:N
            spatial_filtered_frames{i} = conv2(frames{i}, spatial_filter, 'same');
        end
    end

    % Apply temporal filter
    fprintf('Applying temporal filter...\n');
    [temporal_filtered_frames, noise_estimate] = applyTemporalFilter(spatial_filtered_frames, temporal_filter);
    
    % Detect and mask
    masked_frames = detectAndMask(frames, temporal_filtered_frames, 1.5 * noise_estimate);

end