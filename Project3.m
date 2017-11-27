%% Dense Optical Flow
%  Dylan Bradbury
%  Computer Vision I
%  Project III
%  December 1, 2017

close all
clear
clc

%[~, gray] = loadImagesFromDirectory('data/LKTestpgm', 'pgm');
[~, gray] = loadImagesFromDirectory('data/toys1', 'gif');
%[~, gray] = loadImagesFromDirectory('data/toys2', 'gif');

i1 = im2double(gray{1});
i2 = im2double(gray{3});

pyramid1 = pyramidReduce(i1, 2, 1);
pyramid2 = pyramidReduce(i2, 2, 1);

for i = 1:2
    
    [u, v] = LKOpticalFlow(pyramid1{i}, pyramid2{i}, 5);

    figure();
    imshow(pyramid2{i});
    hold on;
    quiver(u, v, 2, 'g');
    hold off;
    
end