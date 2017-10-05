%% function playFrames

function playFrames(frames)

    N = length(frames);
    [rows, cols, channels] = size(frames{1});
    
    truecolorArray = zeros(rows, cols, 3, length(frames));

    for i = 1:N

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

        F(N) = struct('cdata', [], 'colormap', []);
        for j = 1:N
            imshow(truecolorArray(:,:,:,j));
            drawnow
            F(j) = getframe(gcf);
        end

    end

end