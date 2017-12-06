%  Exploiting the Circulant Structure of Tracking-by-detection with Kernels
%
%  Main script for tracking, with a gaussian kernel.
%
%  João F. Henriques, 2012
%  http://www.isr.uc.pt/~henriques/

close all;
clear;
clc;

%choose the path to the videos (you'll be able to choose one with the GUI)
base_path = '../data/';

%occlusion recovery parameters
occlusion_recovery = true;

if occlusion_recovery
    
    w = 5; %exclude (2w + 1)x(2w + 1) window around peak response for sidelobes
    n_min = 20;
    n_max = 40; %hankel complexity
    threshold = 10; %psr threshold for occlusion
    occluded = false;
    
end

%parameters according to the paper
padding = 1;					%extra area surrounding the target
output_sigma_factor = 1/16;		%spatial bandwidth (proportional to target)
sigma = 0.2;					%gaussian kernel bandwidth
lambda = 1e-2;					%regularization
interp_factor = 0.075;			%linear interpolation factor for adaptation

%notation: variables ending with f are in the frequency domain.

%ask the user for the video
video_path = choose_video(base_path);

%user cancelled
if isempty(video_path)
    return
end

[img_files, pos, target_sz, resize_image, ground_truth, video_path] = load_video_info(video_path);

if occlusion_recovery
    ppos = zeros(2 * numel(img_files), 1); %vector to store previous positions
    ppos(1:2) = pos';
end

%window size, taking padding into account
sz = floor(target_sz * (1 + padding));

%desired output (gaussian shaped), bandwidth proportional to target size
output_sigma = sqrt(prod(target_sz)) * output_sigma_factor;
[rs, cs] = ndgrid((1:sz(1)) - floor(sz(1)/2), (1:sz(2)) - floor(sz(2)/2));
y = exp(-0.5 / output_sigma^2 * (rs.^2 + cs.^2));
yf = fft2(y);

%store pre-computed cosine window
cos_window = hann(sz(1)) * hann(sz(2))';

time = 0;  %to calculate FPS
positions = zeros(numel(img_files), 2);  %to calculate precision

for frame = 1:numel(img_files)
    
	%load image
	im = imread([video_path img_files{frame}]);
    if size(im,3) > 1
		im = rgb2gray(im);
    end
	if resize_image
		im = imresize(im, 0.5);
	end
	
	tic()
	
	%extract and pre-process subwindow
	x = get_subwindow(im, pos, sz, cos_window);
	
    if frame > 1
        
		%calculate response of the classifier at all locations
		k = dense_gauss_kernel(sigma, x, z);
		response = real(ifft2(alphaf .* fft2(k))); %(Eq. 9)
		
		%target location is at the maximum response
		[row, col] = find(response == max(response(:)), 1);
        
        %check psr for occlusion
        if occlusion_recovery
            
            [rows, cols] = size(response);
            sidelobe = true(rows, cols);
            sidelobe(max((row - w), 1):min((row + w), rows), max((col - w), 1):min((col + w), cols)) = false;
            psr = (response(row, col) - mean(response(sidelobe))) / std(response(sidelobe));
            
            if psr <= threshold
                
%                 H_x = zeros(n);
%                 H_y = zeros(n);
%                 c_beg = max(frame - (2 * n) + 2, 1);
%                 
%                 for i = 1:n
%                     H_x(:,i) = positions(c_beg:c_beg + n - 1, 1);
%                     H_y(:,i) = positions(c_beg:c_beg + n - 1, 2);
%                     c_beg = c_beg + 1;
%                 end
%                 
%                 A_x = H_x(1:(end - 1), 1:(end - 1));
%                 b_x = H_x(1:(end - 1), end);
%                 C_x = H_x(end, 1:(end - 1));
%                 
%                 v_x = A_x \ b_x;
%                 v_x(abs(v_x) == inf) = 0;
%                 
%                 X = C_x * v_x;
%                 
%                 A_y = H_y(1:(end - 1), 1:(end - 1));
%                 b_y = H_y(1:(end - 1), end);
%                 C_y = H_y(end, 1:(end - 1));
%                 
%                 v_y = A_y \ b_y;
%                 v_y(abs(v_y) == inf) = 0;
%                 
%                 Y = C_y * v_y;
%                 
%                 pos = [X, Y];

                n = floor(frame / 2);

                if mod(n, 2)
                    n = n - 1;
                end

                H = zeros(2 * n, n);
                h = positions((frame - (2 * (n - 1))):frame, :)';
                h = h(:);

                for i = 1:n
                    H(:,i) = h(((2 * (i - 1)) + 1):((2 * (i - 1)) + (2 * n)));
                end

                if ~occluded
                    A = H(1:(end - 2), 1:(end - 1));
                    b = H(1:(end - 2), end);
                    v = A \ b;
                end
                
                C = H((end - 1):end, 1:(end - 1));
                X = C(:,(end - size(v, 1) + 1):end) * v;
                pos = X';
                
                occluded = true;
                
            else
                
                occluded = false;
                pos = pos - floor(sz/2) + [row, col];
                
            end
            
            ppos((2 * frame - 1):(2 * frame)) = pos';
                
        else
            
    		pos = pos - floor(sz/2) + [row, col];
            
        end
        
    end

    if ~occluded

        %get subwindow at current estimated target position, to train classifer
        x = get_subwindow(im, pos, sz, cos_window);

        %Kernel Regularized Least-Squares, calculate alphas (in Fourier domain)
        k = dense_gauss_kernel(sigma, x);
        new_alphaf = yf ./ (fft2(k) + lambda);   %(Eq. 7)
        new_z = x;

        if frame == 1  %first frame, train with a single image
            alphaf = new_alphaf;
            z = x;
        else
            %subsequent frames, interpolate model
            alphaf = (1 - interp_factor) * alphaf + interp_factor * new_alphaf;
            z = (1 - interp_factor) * z + interp_factor * new_z;
        end
        
    end
    
	%save position and calculate FPS
	positions(frame,:) = pos;
	time = time + toc();
	
	%visualization
	rect_position = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
	if frame == 1  %first frame, create GUI
		figure()
		im_handle = imshow(im, 'Border','tight', 'InitialMag',200);
		rect_handle = rectangle('Position',rect_position, 'EdgeColor','g');
	else
		try  %subsequent frames, update GUI
			set(im_handle, 'CData', im)
			set(rect_handle, 'Position', rect_position)
            if occlusion_recovery
                if occluded
                    set(rect_handle, 'EdgeColor', 'r')
                else
                    set(rect_handle, 'EdgeColor', 'g')
                end
            end
        catch %user has closed the window
			return
		end
	end
	
	drawnow
    %pause(0.05)  %uncomment to run slower
    
end

if resize_image, positions = positions * 2; end

disp(['Frames-per-second: ' num2str(numel(img_files) / time)])

%show the precisions plot
show_precision(positions, ground_truth, video_path)
