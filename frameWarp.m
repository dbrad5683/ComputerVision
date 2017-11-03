%% function frameWarp

function img = frameWarp(img, frame)
% img - image on which to warp the frame
% frame - image to be warp into img

% Row, Col corners of frame
r = [1; 1; size(frame, 1); size(frame, 1)];
c = [1; size(frame, 2); size(frame, 2); 1];

figure();
imshow(img);
title('Select 4 Clockwise Corner Points Starting With Upper Left Corner');

% Row, Col corners of warped frame in img
[cp, rp] = ginput(4);

h = calculateHomography([r, c, rp, cp]);

minX = min(cp);
maxX = max(cp);
minY = min(rp);
maxY = max(rp);

for y = minY:maxY
    for x = minX:maxX

        p = h \ [x; y; 1];
        p = p ./ p(3);
        
        for d = 1:size(img, 3)
            
            if p(1) >= 1 && p(1) <= size(frame, 2) && p(2) >= 1 && p(2) < size(frame, 1)
                img(y,x,d) = interp2(frame(:,:,d), p(1), p(2));
            end
            
        end
    end
end

imshow(img);

end