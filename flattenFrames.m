%% function flattenFrames

function flat_frames = flattenFrames(frames, pad)
% frames - cell array of grayscale images
% pad - number of zeros to pad on each end of the data

    N = length(frames);
    [rows, cols] = size(frames{1});

    % Flatten frames into matrix and add padding
    flat_frames = zeros(rows * cols, N + (2 * pad));

    % Pad with first and last frames
    for i = (1:pad)
        flat_frames(:,i) = frames{1}(:);
        flat_frames(:,i + N + pad) = frames{end}(:);
    end

    % Fill up the rest
    for i = (1:N)
        flat_frames(:,i + pad) = frames{i}(:);
    end

end
