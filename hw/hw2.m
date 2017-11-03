close all;
clear;
clc;

%% 1

% Generate images
std = 2;
clean = 128 * ones(256, 256, 10);
noise = std * randn(256, 256, 10);
images = clean + noise;

% Estimate noise
[average_noise_1, max_noise_1] = EST_NOISE(images);

%% 2

% Make template
template = ones(3, 3) / 9;
images_filtered = zeros(254, 254, 10);

% Filter
for i = 1:10
    images_filtered(:,:,i) = conv2(images(:,:,i), template, 'valid');
end

% Estimate noise
[average_noise_2, max_noise_2] = EST_NOISE(images_filtered);

%% 3
gaussian = make2DGaussian(1.4, ceil(5 * 1.4));
[row, col] =  separateFilter(gaussian);
 
%% 4
I_hat = [10 10 10 10 10 40 40 40 40 40];
a = [1 1 1 1 1]/5;
b = [1 2 4 2 1]/10;

I_hat_a = conv(I_hat, a, 'valid');
I_hat_b = conv(I_hat, b, 'valid');

I_hats = repmat(I_hat, 1, 1, 10) + randn(1, 10, 10);

[average_noise_3, max_noise_3] = EST_NOISE(I_hats);

I_hats_filtered_a = zeros(1, 6, 10);
I_hats_filtered_b = zeros(1, 6, 10);

for i = 1:10
    I_hats_filtered_a(:,:,i) = conv(I_hats(:,:,i), a, 'valid');
    I_hats_filtered_b(:,:,i) = conv(I_hats(:,:,i), b, 'valid');
end
    
[average_noise_3a, max_noise_3a] = EST_NOISE(I_hats_filtered_a);
[average_noise_3b, max_noise_3b] = EST_NOISE(I_hats_filtered_b);

%% 6
im = zeros(8,8);

for i = 0:7
    for j = 0:7
        im(i+1,j+1) = abs(i-j);
    end
end

im_filtered = medfilt2(im);

%% 7
f = [4 4 4 4 8 8 8 8];
t = [1 2 1] ./ 4;

a = conv(f, t, 'valid');
m = [4 4 4 8 8 8];


