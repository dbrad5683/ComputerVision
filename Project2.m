%% Image Mosaicing
%  Dylan Bradbury
%  Computer Vision I
%  Project II
%  November 3, 2017

close all
clear
clc

[color, ~] = loadImagesFromDirectory('data/DanaOffice', '.JPG');
% [color, ~] = loadImagesFromDirectory('data/DanaHallWay1', '.JPG');
% [color, ~] = loadImagesFromDirectory('data/DanaHallWay2', '.JPG');

% Choose 2
i1 = 2;
i2 = 1;

img1 = color{i1};
img2 = color{i2};

scale_factor = 1;
ncc_window_radius = 20;
homography_iterations = 10000;

mosaic = makeMosaic(img1, img2, ncc_window_radius, homography_iterations, scale_factor);

figure();
imshow(mosaic);
