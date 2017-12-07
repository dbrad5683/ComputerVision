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
    n_max = 10; %hankel complexity
    threshold = .15; %psr threshold for occlusion
    occluded = false;
    save_figures = true;
    
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

[img_files, pos, target_sz, resize_image, ground_truth, mil_track, video_path] = load_video_info(video_path);

if occlusion_recovery
    cm_fname = [video_path '../cm.txt'];
    if exist(cm_fname, 'file') == 2
        f = fopen(cm_fname);
        cm_track = textscan(f, '%f,%f,%f,%f');  %[x, y, width, height]
        cm_track = cat(2, cm_track{:});
        fclose(f);
    end
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
if occlusion_recovery
    occ = zeros(numel(img_files), 1);
    psr = zeros(numel(img_files), 1);
end

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
            psr(frame) = (response(row, col) - mean(response(sidelobe))) / std(response(sidelobe));
            
            if psr(frame) <= threshold * max(psr)

                occluded = true;
                
                n = min(floor(frame / 2), n_max);

                if mod(n, 2)
                    n = n - 1;
                end

                H = zeros(2 * n, n);
                h = positions((frame - (2 * (n - 1))):frame, :)';
                h = h(:);

                for i = 0:(n - 1)
                    H(:,i + 1) = h(((2 * i) + 1):((2 * i) + (2 * n)));
                end

                A = H(1:(end - 2), 1:(end - 1));
                b = H(1:(end - 2), end);
                v = A \ b;
                
                C = H((end - 1):end, 1:(end - 1));
                pos = (C * v)';
                
            else
                
                occluded = false;
                
                pos = pos - floor(sz/2) + [row, col];
                
            end
            
            occ(frame) = occluded;
                
        else
            
    		pos = pos - floor(sz/2) + [row, col];
            
        end
        
    end

    if (~occlusion_recovery || (occlusion_recovery && ~occluded))

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
    if occlusion_recovery
        cm_rect_position = [cm_track(frame,[2,1]) - target_sz([2,1])/2, target_sz([2,1])];
        mil_rect_position = [mil_track(frame,[1,2]), mil_track(frame,[3,4])];
    end
	if frame == 1  %first frame, create GUI
		figure()
		im_handle = imshow(im, 'Border','tight', 'InitialMag',200);
		rect_handle = rectangle('Position',rect_position, 'EdgeColor','g', 'LineWidth', 2);
        if occlusion_recovery
            cm_rect_handle = rectangle('Position',cm_rect_position, 'EdgeColor','c', 'LineWidth', 2);
            mil_rect_handle = rectangle('Position',mil_rect_position, 'EdgeColor','y', 'LineWidth', 2);
        end
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
                set(cm_rect_handle, 'Position', cm_rect_position)
                set(mil_rect_handle, 'Position', mil_rect_position)
            end
        catch %user has closed the window
			return
		end
	end
	
	drawnow
    
    if (occlusion_recovery && save_figures)
        outdir = [video_path '../out/'];
        if ~isdir(outdir)
            mkdir(outdir);
        end
        parts = split(img_files{frame}, '.');
        fname = [outdir char(parts{1}) '.eps'];
        print(fname, '-depsc');
    end
    
    %pause(0.05)  %uncomment to run slower
    
end

if resize_image, positions = positions * 2; end

if ~occlusion_recovery
	f = fopen([video_path '../cm.txt'], 'w+');
    for i = 1:size(positions, 1)
        fprintf(f, '%f,%f,%f,%f\n', positions(i,1), positions(i,2), target_sz(1,1), target_sz(1,2));
    end
	fclose(f);
else
	f = fopen([video_path '../occ.txt'], 'w+');
    for i = 1:size(positions, 1)
        fprintf(f, '%f,%f,%f,%f,%d\n', positions(i,1), positions(i,2), target_sz(1,1), target_sz(1,2), occ(i));
    end
	fclose(f);
end

disp(['Frames-per-second: ' num2str(numel(img_files) / time)])

%show the precisions plot
figure()
hold on;
show_precision(positions, ground_truth, 'g')
if occlusion_recovery
    show_precision(cm_track(:,1:2), ground_truth, 'c')
    show_precision(mil_track(:,[2,1]) + repmat(target_sz([1,2])/2, size(mil_track, 1), 1), ground_truth, 'y')
end
legend({'Occlusion Recovery', 'CM Track', 'MIL Track'}, 'Location', 'SouthEast');
hold off;

if (occlusion_recovery && save_figures)
    outdir = [video_path '../out/'];
    if ~isdir(outdir)
        mkdir(outdir);
    end
    fname = [outdir 'precision.eps'];
    print(fname, '-depsc');
end