%% function detectAndMask

function masked_frames = detectAndMask(frames, filtered_frames, threshold)
% frames - cell array of images
% scale - number of standard deviations for threshold

    masked_frames = frames;
    for i = 1:length(frames)
        masked_frames{i}(filtered_frames{i} >= threshold) = 1;
    end
    
end