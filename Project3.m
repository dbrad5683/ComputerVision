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
i2 = im2double(gray{2});

% for w = [1, 2, 5, 10, 20, 40]
%     
%     [u, v] = LKOpticalFlow(i1, i2, w, 2, 1);
% 
%     figure();
%     imshow(i1);
%     hold on;
%     quiver(u, v, 5, 'g');
%     title(sprintf('w = %d', w));
%     hold off;
% 
%     print(sprintf('%d', w), '-dpdf');
%   
% end
% 
% return 

pyramid1 = pyramidReduce(i1, 2, 1);
pyramid2 = pyramidReduce(i2, 2, 1);

for i = 1:2
    
    [u, v] = LKOpticalFlow(pyramid1{i}, pyramid2{i}, 20, 3, 3);

    figure();
    imshow(pyramid1{i});
    hold on;
    quiver(u, v, 2, 'g');
    hold off;
    
    figure();
    hold on;
    quiver(flipud(u), flipud(v), 2);
    hold off;
    
end