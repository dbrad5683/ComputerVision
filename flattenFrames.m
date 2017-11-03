%% function flattenFrames

function flat_frames = flattenFrames(frames)
% frames - cell array of grayscale images

    N = length(frames);
    [rows, cols] = size(frames{1});

    % Flatten frames into 2D array where each column is an image
    flat_frames = zeros(rows * cols, N);
    for i = 1:N
        flat_frames(:,i) = frames{i}(:);
    end

end
