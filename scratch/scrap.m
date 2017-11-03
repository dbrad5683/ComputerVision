%%

sz = size(frame1) + 300;
h = sz(1); w = sz(2);
%create a world coordinate system
outputview = imref2d([h,w]);
mosaic = imwarp(frame1, affine2d(eye(3)), 'OutputView', outputview);

tform = projective2d(hT);
mosaic_new = imwarp(frame2, tform, 'OutputView', outputview);

figure();
imshow(mosaic, 'initialmagnification','fit');
figure();
imshow(mosaic_new, 'initialmagnification','fit');

%%

%create a object to overlay one image over another
halphablender = vision.AlphaBlender('Operation', 'Binary mask', 'MaskSource', 'Input port');
% Creat a mask which specifies the region of the target image.
% BY Applying geometric transformation to image
mask = imwarp(ones(size(frame2)), affine2d(hT), 'OutputView', outputView) >= 1;
%overlays one image over another
mosaicfinal = step(halphablender, mosaic, mosaic_new, mask);
%show results
figure,imshow(frame1,'initialmagnification','fit');
figure,imshow(frame2,'initialmagnification','fit');
figure,imshow(mosaicfinal,'initialmagnification','fit');

%%
top = min(1, r.YWorldLimits(1));
bot = max(size(frame1, 1), r.YWorldLimits(2));
lef = min(1, 

pt = zeros(3,4);
pt(:,1) = hT * [1;1;1];
pt(:,2) = hT * [N2;1;1];
pt(:,3) = hT * [N2;M2;1];
pt(:,4) = hT * [1;M2;1];
x2 = pt(1,:)./pt(3,:);
y2 = pt(2,:)./pt(3,:);

up = round(min(y2));
Yoffset = 0;
if up <= 0
	Yoffset = -up+1;
	up = 1;
end

left = round(min(x2));
Xoffset = 0;
if left<=0
	Xoffset = -left+1;
	left = 1;
end

[M3 N3 ~] = size(img21);
imgout(up:up+M3-1,left:left+N3-1,:) = img21;
	% img1 is above img21
imgout(Yoffset+1:Yoffset+M1,Xoffset+1:Xoffset+N1,:) = img1;

end


%%
% combined = [frame1, frame2];
% 
% imshow(combined);
% hold on;
% 
% for i = idx
%     plot([scores(i,2), scores(i,4) + size(frame1,2)], [scores(i,1), scores(i,3)], 'r')
% end

% combined = [frame1, frame2];
% 
% imshow(combined);
% hold on;
% 
% for i = round(linspace(1, size(scores, 1), 100))
%     [~,maxI] = max(scores{i,3});
%     if scores{i,3}(maxI) > -1
%         plot([scores{i,1}(2), scores{i,2}(maxI,2) + size(frame1,2)], [scores{i,1}(1), scores{i,2}(maxI,1)], 'r')
%     end
% end