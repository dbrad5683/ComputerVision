%% function loadImagesFromDirectory

function [rgb_frames, gray_frames] = loadImagesFromDirectory(directory, ext)
% directory - directory string containing image files
% ext - image file extension string (jpg, png, tiff, pgm, gif, etc.)

    pattern = [directory filesep '*.' ext];
    files = dir(pattern);
    N = length(files);
    
    rgb_frames = cell(N, 1);
    gray_frames = cell(N, 1);

    for i = 1:N

        f = [files(i).folder filesep files(i).name];
        
        if any(strcmp(ext, {'pgm', 'gif'}))
            gray_frames{i} = imread(f, ext);
        else
            rgb_frames{i} = imread(f);
            gray_frames{i} = rgb2gray(rgb_frames{i});
        end

    end

end