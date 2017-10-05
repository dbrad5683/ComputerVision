%% function playFrames

function playFrames(frames)

    [rows, cols, channels] = size(frames{1});
    
    truecolorArray = zeros(rows, cols, 3, length(frames));

    for i = 1:length(frames)

        if channels == 1
            truecolorArray(:,:,:,i) = repmat(frames{i}, 1, 1, 3);
        else
            truecolorArray(:,:,:,i) = frames{i};
        end

    end

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