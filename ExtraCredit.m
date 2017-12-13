%% Extra Credit: Dense Disparity Map
%  Dylan Bradbury
%  Computer Vision I
%  Extra Credit Project
%  December 13, 2017

close all
clear
clc

[color, gray] = loadImagesFromDirectory('data/ec', 'jpg');

img1 = gray{3};
img2 = gray{4};

disp('Detecting corners...');
corners1 = harrisCornerDetector(img1);
corners2 = harrisCornerDetector(img2);
disp('done.');

disp('Computing NCC...');
ncc_scores = normalizedCrossCorrelation(img1, corners1, img2, corners2, 10);
disp('done.');

disp('Estimating fundamental matrix...');
[f, scores] = estimateFundamentalMatrix(ncc_scores, 10000);
disp('done.');

plotCornerMatches(img1, img2, scores);

disp('Generating dense disparity map...');
[v_disp, h_disp] = denseDisparityMap(img1, img2, f, 5);
disp('done.');
