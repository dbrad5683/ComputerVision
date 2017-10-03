function [average_noise, max_noise] = EST_NOISE(images)

    n = size(images, 3);
    average_pixels = repmat(mean(images, 3), 1, 1, n);
    noise_pixels = sqrt(sum((images - average_pixels).^2, 3) / (n - 1));
    average_noise = mean(noise_pixels(:));
    max_noise = max(noise_pixels(:));

end