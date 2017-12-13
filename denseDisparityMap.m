%% function denseDisparity

function [v_disparity, h_disparity] = denseDisparityMap(img1, img2, f, w)

[rows, cols] = size(img1);

v_disparity = zeros(rows, cols);
h_disparity = zeros(rows, cols);

for r = (w + 1):(rows - w)
    
    for c = (w + 1):(cols - w)
        
        win = double(img1((r - w):(r + w),(c - w):(c + w)));
        win = win ./ sqrt(sum(win(:).^2));
        
        p = f * [c; r; 1];
        
        best_score = -1;
        best_match = [-1, -1];
        
        for i = (w + 1):(cols - w)
            
            y = floor(-((p(1) * i) + p(3)) / p(2)) + 1;
            
            tmp = double(img2((y - w):(y + w),(i - w):(i + w)));
            tmp = tmp ./ sqrt(sum(tmp(:).^2));
            
            score = sum(sum(win .* tmp));
            
            if score > best_score
                best_score = score;
                best_match = [y, i]; % row, col
            end
            
        end
        
        v_disparity(r,c) = abs(r - best_match(1));
        h_disparity(r,c) = abs(c - best_match(2));
        
    end
    
end

v_disparity = 255 * ((v_disparity - min(v_disparity(:))) ./ (max(v_disparity(:)) - min(v_disparity(:))));
h_disparity = 255 * ((h_disparity - min(h_disparity(:))) ./ (max(h_disparity(:)) - min(h_disparity(:))));

end