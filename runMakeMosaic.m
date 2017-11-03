%% Script version of function makeMosaic()

close all
clear
clc

[color, gray] = loadImagesFromDirectory('data/DanaOffice', '.JPG');
% [color, gray] = loadImagesFromDirectory('data/DanaHallWay1', '.JPG');
% [color, gray] = loadImagesFromDirectory('data/DanaHallWay2', '.JPG');

% Choose 2
i1 = 2;
i2 = 1;

img1 = gray{i1};
img2 = gray{i2};

scale_factor = 1;
ncc_window_radius = 20;
homography_iterations = 10000;

% Scale images
disp('Scaling images...');
img1 = img1(1:scale_factor:end, 1:scale_factor:end);
img2 = img2(1:scale_factor:end, 1:scale_factor:end);
disp('done.');

% Detect corner features in each image
disp('Detecting corners...');
corners1 = harrisCornerDetector(img1);
corners2 = harrisCornerDetector(img2);
disp('done.');

% Compute NCC scores for each pair of corners
disp('Computing NCC...');
scores = normalizedCrossCorrelation(img1, corners1, img2, corners2, ncc_window_radius);
disp('done.');

% Estimate the homography
disp('Estimating homography...');
[h, scores_cleaned] = estimateHomography(scores, homography_iterations);
disp('done.');

% Warp the images together to form the mosaic
disp('Warping image...');
mosaic = mosaicWarp(color{i1}, color{i2}, h);
disp('done.');

figure();
imshow(mosaic);
