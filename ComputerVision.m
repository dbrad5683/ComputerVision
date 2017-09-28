classdef ComputerVision < handle
    
    properties
        
        rgbFrames = {}
        grayFrames = {}
        numFrames = 0
        rows = 0
        cols = 0
        numels = 0
        
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
                
                self.rgbFrames{i} = im2double(imread(f));

            end
            
            self.numels = self.rows * self.cols;
            
            for i = 1:self.numFrames
                self.grayFrames{i} = rgb2gray(self.rgbFrames{i});
            end
            
        end
        
        function detections = applyTestTemporalFilter(self, threshold)
           
            % Create the mask
            mask = [1,0,-1];
            
            % Calculate padding
            pad = floor(length(mask)/2);
            
            % Flatten frames into matrix and add padding
            flatFrames = zeros(self.numels, self.numFrames + (2 * pad));
            
            for i = (1:self.numFrames) + pad
                flatFrames(:,i) = self.grayFrames{i - pad}(:);
            end
            
            % Convolve and trim padding
            flatFilteredFrames = abs(conv2(flatFrames, mask, 'same'));
            flatFilteredFrames = flatFilteredFrames(:,(1:self.numFrames)+pad);
            
            % Threshold and detect
            flatDetections = zeros(self.numels, self.numFrames);
            flatDetections(flatFilteredFrames >= threshold) = 1;
            
            % Reconstruct
            detections = cell(self.numFrames, 1);
            
            for i = 1:self.numFrames
                detections{i} = reshape(flatDetections(:, i), self.rows, self.cols);
            end
            
        end
        
        function truecolorArray = framesToTrucolorArray(self, frames)
            
            truecolorArray = zeros(self.rows, self.cols, 3, self.numFrames);
            
            for i = 1:self.numFrames
                
                truecolorArray(:,:,:,i) = repmat(frames{i}, 1, 1, 3);
                
            end
            
        end

    end
    
end