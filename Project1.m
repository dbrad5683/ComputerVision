%% Motion Detection using Simple Image Filtering
%  Dylan Bradbury
%  Computer Vision I
%  Project I
%  October 6, 2017

close all;
clear;
clc;

% Parameters
ssigma = [1, 2, 3];
tsigma = [1, 2, 3];

% Load data
fprintf('Loading data...\n');
%[~, frames] = loadImagesFromDirectory('data/Office', 'jpg');
[~, frames] = loadImagesFromDirectory('data/RedChair', 'jpg');
%[~, frames] = loadImagesFromDirectory('data/EnterExitCrossingPaths2cor', 'jpg');

% Initialize spatial filters
fprintf('Initializing spatial filters...\n');
spatial_filters{1} = 1;
spatial_filters{2} = ones(3) / 9;
spatial_filters{3} = ones(5) / 25;
for i = 1:length(ssigma)
    % Calculate number of elements to be an integer at least 5 * tsigma
    N = ceil(5 * tsigma(i));
    spatial_filters{i + 3} = make2DGaussian(N, ssigma(i));
end

% Initialize temporal filters
fprintf('Initializing temporal filters...\n');
temporal_filters{1} = [-1, 0, 1];
for i = 1:length(tsigma)
    % Calculate number of elements to be an integer at least 5 * tsigma
    N = ceil(5 * tsigma(i));
    % Ensure N is even so the filter is odd after differentiating
    if mod(N, 2) == 1
        N = N + 1;
    end
    % Make filters
    temporal_filters{i + 1} = diff(make1DGaussian(N, tsigma(i))); 
end

% Allocate output data structure and run motionDetector
num_temporal_filters = length(temporal_filters);
num_spatial_filters = length(spatial_filters);
results = cell(num_temporal_filters, num_spatial_filters);
for i = 1:num_temporal_filters
    
    for j = 1:num_spatial_filters
        
        fprintf('Temporal filter %d/%d, Spatial filter %d/%d\n', i, num_temporal_filters, j, num_spatial_filters);
        results{i,j} = motionDetector(frames, temporal_filters{i}, spatial_filters{j});
        
    end
    
end