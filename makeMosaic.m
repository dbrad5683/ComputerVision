%% function makeMosaic

function mosaic = makeMosaic(img1, img2, ncc_window_radius, homography_iterations, scale_factor)
% img1 - image 1
% img2 - image 2
% ncc_window_radius - radius (r) of correlation window (2r + 1)x(2r + 1)
% homography_iterations - RANSAC iterations for homography estimation

    % Scale images
    disp('Scaling images...');
    img1 = img1(1:scale_factor:end, 1:scale_factor:end);
    img2 = img2(1:scale_factor:end, 1:scale_factor:end);
    disp('done.');
    
    img1_gray = rgb2gray(img1);
    img2_gray = rgb2gray(img2);

    % Detect corner features in each image
    disp('Detecting corners...');
    corners1 = harrisCornerDetector(img1_gray);
    corners2 = harrisCornerDetector(img2_gray);
    disp('done.');
    
    % Compute NCC scores for each pair of corners with a window radius of 11
    disp('Computing NCC...');
    scores = normalizedCrossCorrelation(img1_gray, corners1, img2_gray, corners2, ncc_window_radius);
    disp('done.');
    
    % Estimate the homography
    disp('Estimating homography...');
    [h, ~] = estimateHomography(scores, homography_iterations);
    disp('done.');
    
    % Warp the images together to form the mosaic
    disp('Warping image...');
    mosaic = mosaicWarp(img1, img2, h);
    disp('done.');
    
end