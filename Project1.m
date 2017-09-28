%% Project 1: Motion Detection using Simple Image Filtering
% Dylan Bradbury

close all;
clear;
clc;

% Initialize processing class
cv = ComputerVision();

% Load data
%cv.loadImagesFromDirectory('data/Office', '.jpg');
%cv.loadImagesFromDirectory('data/RedChair', '.jpg');
cv.loadImagesFromDirectory('data/EnterExitCrossingPaths2cor', '.jpg');

% simple_temporal_filter = [-1, 0, 1];
% simple_temporal_filtered_frames = cv.applyTemporalFilter(simple_temporal_filter);
% cv.playFrames(simple_temporal_filtered_frames);

tsigma = 1;
gaussian_temporal_filter = cv.makeTemporalGaussianFilter(tsigma, 9);
gaussian_temporal_filtered_frames = cv.applyTemporalFilter(gaussian_temporal_filter);
cv.playFrames(gaussian_temporal_filtered_frames, 1, 30);