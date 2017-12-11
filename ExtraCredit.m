%% Dense Disparity Map
%  Dylan Bradbury
%  Computer Vision I
%  Extra Credit Project
%  December 12, 2017

close all
clear
clc

[color, gray] = loadImagesFromDirectory('data/ec', 'jpg');

img1 = gray{1};
img2 = gray{2};

disp('Detecting corners...');
corners1 = harrisCornerDetector(img1);
corners2 = harrisCornerDetector(img2);
disp('done.');

% Compute NCC scores for each pair of corners with a window radius of 11
disp('Computing NCC...');
ncc_scores = normalizedCrossCorrelation(img1, corners1, img2, corners2, 25);
disp('done.');

% Estimate the fundamental matrix
disp('Estimating fundamental matrix...');
[f, scores] = estimateFundamentalMatrix(ncc_scores, 1000);
disp('done.');

plotCornerMatches(img1, img2, scores);

w = 10;
[rows, cols] = size(img1);

for y = (w + 1):(rows - w)
    for x = (w + 1):(cols - w)
        
        win = img1((y - w):(y + w),(x - w):(x + w));
        p = f * [x; y; 1];
        
        for i = 1:cols
            
            col = (p(1) * i) + 1;
            row = p(3) + (p(2) * i);
            
        end
        
    end
end