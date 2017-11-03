%% function plotCornerMatches

function plotCornerMatches(img1, img2, scores)

    combined = [img1, img2];
    xoffset = size(img1, 2);
    
    figure();
    imshow(combined);
    
    hold on
    
    colors = {'b', 'k', 'r', 'g', 'y', 'c', 'm'};
    nc = length(colors);
    
    for i = 1:size(scores, 1)
        
        p = scores(i,1:4);
        plot([p(2), p(4) + xoffset], [p(1), p(3)], colors{mod(i, nc) + 1});
        
    end
    
    hold off

end