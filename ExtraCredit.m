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
ncc_scores = normalizedCrossCorrelation(img1, corners1, img2, corners2, 10);
disp('done.');

% Estimate the fundamental matrix
disp('Estimating fundamental matrix...');
[f, scores] = estimateFundamentalMatrix(ncc_scores, 10000);
disp('done.');

plotCornerMatches(img1, img2, scores);

w = 20;
[rows, cols] = size(img1);

v_disparity = zeros(rows, cols);
h_disparity = zeros(rows, cols);

for r = (w + 1):(rows - w)
    
    for c = (w + 1):(cols - w)
        
        win = double(img1((r - w):(r + w),(c - w):(c + w)));
        win = win ./ sqrt(sum(win(:).^2));
        
        p = f * [c; r; 1];
        
        best_score = -1;
        best_match = [-1, -1];
        
        for i = (w + 1):(cols - w)
            
            y = floor(-((p(1) * i) + p(3)) / p(2)) + 1;
            
            tmp = double(img2((y - w):(y + w),(i - w):(i + w)));
            tmp = tmp ./ sqrt(sum(tmp(:).^2));
            
            score = sum(sum(win .* tmp));
            
            if score > best_score
                best_score = score;
                best_match = [y, i]; % row, col
            end
            
        end
        
        v_disparity(r,c) = abs(r - best_match(1));
        h_disparity(r,c) = abs(c - best_match(2));
        
    end
    
    disp(r);
    
end

v_disparity = 255 * ((v_disparity - min(v_disparity(:))) ./ (max(v_disparity(:)) - min(v_disparity(:))));
h_disparity = 255 * ((h_disparity - min(h_disparity(:))) ./ (max(h_disparity(:)) - min(h_disparity(:))));
