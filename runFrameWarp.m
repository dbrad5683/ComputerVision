close all
clear
clc

% [bg, gray] = loadImagesFromDirectory('data/DanaOffice', '.JPG');
[bg, gray] = loadImagesFromDirectory('data/DanaHallWay1', '.JPG');
% [bg, gray] = loadImagesFromDirectory('data/DanaHallWay2', '.JPG');
[ctrump, trump] = loadImagesFromDirectory('data/trump', '.jpg');

i = frameWarp(bg{1}, ctrump{1});