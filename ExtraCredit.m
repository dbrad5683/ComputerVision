%% Dense Disparity Map
%  Dylan Bradbury
%  Computer Vision I
%  Extra Credit Project
%  December 12, 2017

close all
clear
clc

[color, gray] = loadImagesFromDirectory('data/ec', 'jpg');

scores = denseDisparity(gray{3}, gray{4}, 25, 1000);

plotCornerMatches(color{1}, color{2}, scores);