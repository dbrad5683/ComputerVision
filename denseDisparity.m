%% function denseDisparity

function [f, scores] = denseDisparity(img1, img2, ncc_window_radius, n_iter)
% img1 - image 1
% img2 - image 2
% ncc_window_radius - radius (r) of correlation window (2r + 1)x(2r + 1)
% n_iter - RANSAC iterations for fundamental matrix estimation

    % Detect corner features in each image
    disp('Detecting corners...');
    corners1 = harrisCornerDetector(img1);
    corners2 = harrisCornerDetector(img2);
    disp('done.');
    
    % Compute NCC scores for each pair of corners with a window radius of 11
    disp('Computing NCC...');
    scores = normalizedCrossCorrelation(img1, corners1, img2, corners2, ncc_window_radius);
    disp('done.');
   
    return
    
    % Estimate the fundamental matrix
    disp('Estimating fundamental matrix...');
    f = estimateFundamentalMatrix(scores, n_iter);
    disp('done.');
    
    [rows, cols] = size(img1);
    
    for i = 1:rows
        for j = 1:cols
            ;
        end
    end
    
end