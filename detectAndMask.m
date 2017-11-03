%% function detectAndMask

function masked_frames = detectAndMask(original_frames, filtered_frames, threshold)
% original_frames - cell array of original image frames
% filtered_frames - cell array of filtered image frames for detection
% threshold - detection threshold

    N = length(original_frames);
    [rows, cols] = size(original_frames{1});
    
    masked_frames = cell(N, 1);
    
    for i = 1:N
        mask = (filtered_frames{i} >= threshold);
        masked_frames{i} = zeros(rows, cols);
        masked_frames{i}(mask) = original_frames{i}(mask);
    end
    
end