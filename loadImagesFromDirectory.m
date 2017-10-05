%% function loadImagesFromDirectory

function [rgb_frames, gray_frames] = loadImagesFromDirectory(directory, ext)
% directory - directory containing image files
% ext - image file extension (.jpg, .png, .tiff, etc.)

    pattern = [directory filesep '*' ext];
    files = dir(pattern);
    N = length(files);
    
    rgb_frames = cell(N, 1);
    gray_frames = cell(N, 1);

    for i = 1:N

        f = [files(i).folder filesep files(i).name];
        rgb_frames{i} = im2double(imread(f));
        gray_frames{i} = rgb2gray(rgb_frames{i});

    end

end