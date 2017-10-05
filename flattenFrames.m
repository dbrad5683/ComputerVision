%% function flattenFrames

function flat_frames = flattenFrames(frames, pad)
% frames - cell array of grayscale images
% pad - number of zeros to pad on each end of the data

    N = length(frames);
    [rows, cols] = size(frames{1});

    % Flatten frames into matrix and add padding
    flat_frames = zeros(rows * cols, N + (2 * pad));

    for i = (1:length(frames))
        flat_frames(:,i + pad) = frames{i}(:);
    end

end