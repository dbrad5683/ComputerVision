%% Motion Detection using Simple Image Filtering
%  Dylan Bradbury
%  Computer Vision I
%  Project I
%  October 6, 2017

close all;
clear;
clc;

% Parameters
ssigma = [1 2 3];
tsigma = [1 2 3];

% Load data
fprintf('Loading data...\n');
[~, frames] = loadImagesFromDirectory('data/Office', '.jpg');
%[~, frames] = loadImagesFromDirectory('data/RedChair', '.jpg');
%[~, frames] = loadImagesFromDirectory('data/EnterExitCrossingPaths2cor', '.jpg');

% Initialize spatial filters
fprintf('Initializing spatial filters...\n');
identity = [0 0 0; 0 1 0; 0 0 0];
box3 = ones(3) / 9;
box5 = ones(5) / 25;
gaussian_spatial_filter = cell(length(ssigma), 1);
for i = 1:length(ssigma)
    
    gaussian_spatial_filter{i} = make2DGaussian(ssigma(i));
    
end

% Initialize temporal filters
fprintf('Initializing temporal filters...\n');
simple_temporal_filter = [-1, 0, 1];
gaussian_temporal_filter = cell(length(tsigma), 1);
for i = 1:length(tsigma)
    
    % Calculate number of elements to be at least 5 * tsigma
    N = ceil(5 * tsigma(i));
    
    % Make N even so the filter is odd after taking differences
    if mod(N, 2) == 1
        N = N + 1;
    end
    
    % Make filters
    gaussian_temporal_filter{i} = diff(make1DGaussian(N, tsigma(i)));
    
end

% Build filter list
spatial_filters{1} = identity;
spatial_filters{2} = box3;
spatial_filters{3} = box5;
for i = 1:length(gaussian_spatial_filter)
    spatial_filters{3 + i} = gaussian_spatial_filter{i};
end

% Process
fprintf('Processing\n');
spatial_filtered_frames = cell(length(spatial_filters), 1);

% Apply spatial filter and estimate noise
for i = 1:length(spatial_filters)
    
    fprintf('Spatial filter: %d/%d\n', i, length(spatial_filters));
    
    filtered_frames = cell(length(frames), 1);
    
    for j = 1:length(frames)
        filtered_frames{j} = conv2(frames{j}, spatial_filters{i}, 'same');
    end
    
    spatial_filtered_frames{i} = filtered_frames;
    
end

% Apply temporal filter, detect peaks above 3 * noise_floor, and mask
simple_temporal_filtered = cell(length(spatial_filters), 1);
simple_temporal_masked = cell(length(spatial_filters), 1);
gaussian_temporal_filtered = cell(length(spatial_filters), length(gaussian_temporal_filter));
gaussian_temporal_masked = cell(length(spatial_filters), length(gaussian_temporal_filter));

for i = 1:length(spatial_filters)
    
    fprintf('Temporal filter: %d/%d\n', i, length(spatial_filters));
    
    [simple_temporal_filtered{i}, noise] = applyTemporalFilter(spatial_filtered_frames{i}, simple_temporal_filter);
    simple_temporal_masked{i} = detectAndMask(frames, simple_temporal_filtered{i}, noise);
    
    for j = 1:length(gaussian_temporal_filter)
        [gaussian_temporal_filtered{i,j}, noise] = applyTemporalFilter(spatial_filtered_frames{i}, gaussian_temporal_filter{j});
        gaussian_temporal_masked{i,j} = detectAndMask(frames, gaussian_temporal_filtered{i,j}, noise);
    end
    
end