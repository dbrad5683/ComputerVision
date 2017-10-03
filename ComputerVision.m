classdef ComputerVision < handle
    
    properties
        
        rgbFrames = {}
        grayFrames = {}
        numFrames = 0
        numPixels = 0
        rows = 0
        cols = 0
        
    end
    
    methods
        
        function self = ComputerVision; end
        
        function loadImagesFromDirectory(self, directory, ext)
        % directory - directory containing image files
        % ext - image file extension (.jpg, .png, .tiff, etc.)
            
            pattern = [directory filesep '*' ext];
            files = dir(pattern);
            self.numFrames = length(files);
            
            for i = 1:self.numFrames
                
                f = [files(i).folder filesep files(i).name];
                info = imfinfo(f);
                
                if self.rows == 0
                    self.rows = info.Height;
                end
                if self.cols == 0
                    self.cols = info.Width;
                end
                
                self.rgbFrames{i,1} = im2double(imread(f));

            end
            
            self.numPixels = self.rows * self.cols;
            
            for i = 1:self.numFrames
                self.grayFrames{i,1} = rgb2gray(self.rgbFrames{i,1});
            end
            
        end
        
        function temporalGaussianFilter = makeTemporalGaussianFilter(self, sigma, numels)
            
            % Make gaussian
            x = linspace(-numels / 2, numels / 2, numels);
            temporalGaussianFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
            
            % Normalize
            temporalGaussianFilter = temporalGaussianFilter / sum(temporalGaussianFilter);
            
            % First derivative
            temporalGaussianFilter = diff(temporalGaussianFilter);
            
        end
        
        function [filteredFrames, maskedFrames] = applyTemporalFilter(self, template, scale)
        % template - row vector filter template
            
            % Calculate padding
            pad = floor(length(template) / 2);
            
            flatFrames = self.flattenFrames(self.grayFrames, pad);

            % Convolve with mask and trim padding
            flatFilteredFrames = abs(conv2(flatFrames, template, 'same'));
            flatFilteredFrames = flatFilteredFrames(:,(1:self.numFrames) + pad);
            
            % Normalize
            flatFilteredFrames = flatFilteredFrames / max(flatFilteredFrames(:));
            
            % Estimate noise
            noise = self.estimateNoise(flatFilteredFrames);
            
            % Mask
            flatMaskedFrames = zeros(size(flatFilteredFrames));
            flatMaskedFrames(flatFilteredFrames >= scale * noise) = 1;
            
            % Reconstruct
            filteredFrames = cell(self.numFrames, 1);
            maskedFrames = cell(self.numFrames, 1);
            
            for i = 1:self.numFrames
                filteredFrames{i,1} = reshape(flatFilteredFrames(:,i), self.rows, self.cols);
                maskedFrames{i,1} = reshape(flatMaskedFrames(:,i), self.rows, self.cols);
            end
            
        end
        
        function maskedFrames = maskFrames(self, frames, masks)
            
            maskedFrames = frames;
            
            for i = 1:self.numFrames
                for j = 1:3
                    maskedFrames{i}((logical(masks{i})) = 1;
                end
            end
            
        end
        
        function flatFrames = flattenFrames(self, frames, pad)
            
            % Flatten frames into matrix and add padding
            flatFrames = zeros(self.numPixels, self.numFrames + (2 * pad));
            
            for i = (1:self.numFrames)
                flatFrames(:,i + pad) = frames{i}(:);
            end
            
        end
        
        function noise = estimateNoise(self, flatFrames)
            
            average_pixels = sum(flatFrames, 2) / self.numFrames;
            mean_centered_pixels = flatFrames - average_pixels;
            noise = sqrt(sum(mean_centered_pixels.^2, 2) / self.numFrames);
            noise = sum(noise, 1) / self.numPixels;
            
        end
        
        function truecolorArray = framesToTrucolorArray(self, frames)
            
            channels = size(frames{1}, 3);
            
            truecolorArray = zeros(self.rows, self.cols, 3, self.numFrames);
            
            for i = 1:self.numFrames
               
                if channels == 1
                    truecolorArray(:,:,:,i) = repmat(frames{i}, 1, 1, 3);
                else
                    truecolorArray(:,:,:,i) = frames{i};
                end
                
            end
            
        end
        
        function playFrames(self, frames, n, fps)
            
            truecolorArray = self.framesToTrucolorArray(frames);
            
            if license('test', 'image_toolbox')
                
                mov = immovie(truecolorArray);
                implay(mov);
                
            else
                
                imshow(truecolorArray(:,:,:,1));
                ax = gca;
                ax.NextPlot = 'replaceChildren';

                F(self.numFrames) = struct('cdata', [], 'colormap', []);
                for j = 1:self.numFrames
                    imshow(truecolorArray(:,:,:,j));
                    drawnow
                    F(j) = getframe(gcf);
                end

                movie(fig, F, n, fps);

                close(fig);
                
            end
            
        end

    end
    
end