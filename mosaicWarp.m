function mosaic = mosaicWarp(img1, img2, h)

% Find limits of img2 warped into img1 frame
ul = h \ [1; 1; 1];
ur = h \ [size(img2, 2); 1; 1];
ll = h \ [1; size(img2, 1); 1];
lr = h \ [size(img2, 2); size(img2, 1); 1];

ul = ul ./ ul(3);
ur = ur ./ ur(3);
ll = ll ./ ll(3);
lr = lr ./ lr(3);

xborders = [1, size(img1, 2), ul(1), ur(1), ll(1), lr(1)];
yborders = [1, size(img1, 1), ul(2), ur(2), ll(2), lr(2)];

minX = min(xborders);
maxX = max(xborders);
minY = min(yborders);
maxY = max(yborders);

% Round away from zero
minX = sign(minX) * ceil(abs(minX));
maxX = sign(maxX) * ceil(abs(maxX));
minY = sign(minY) * ceil(abs(minY));
maxY = sign(maxY) * ceil(abs(maxY));

offset = abs([1; 1; 1] - [minX; minY; 1]);

imgX = (offset(1) + 1):(offset(1) + size(img1, 2));
imgY = (offset(2) + 1):(offset(2) + size(img1, 1));

rows = maxY - minY + 1;
cols = maxX - minX + 1;
mosaic = uint8(zeros(rows, cols, size(img1, 3)));

mosaic(imgY,imgX,:) = img1;

for y = 1:rows
    for x = 1:cols
        
        p = h * ([x; y; 1] - offset);
        p = p ./ p(3);
        
        xp = p(1);
        yp = p(2);
        
        for d = 1:size(img1, 3)

            if xp >= 1 && xp <= size(img2, 2) && yp >= 1 && yp < size(img2, 1)

                val = interp2(img2(:,:,d), xp, yp);

                 if mosaic(y, x, d) > 0
                     mosaic(y, x, d) = uint8((double(mosaic(y, x, d)) + double(val)) / 2);
                 else
                     mosaic(y, x, d) = val;
                 end
                 
            end
            
        end
    end
end
