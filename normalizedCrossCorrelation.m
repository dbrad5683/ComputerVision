%% function normalizedCrossCorrelation

function scores = normalizedCrossCorrelation(img1, corners1, img2, corners2, win)
% img1 - image 1
% corners1 - corners of image 1
% img2 - image 2
% corners2 - corners of image 2
% win - radius of correlation window such that window is (2 * win + 1)x(2 * win + 1)

    % Get corner indices of each image
    [r1, c1] = find(corners1 > 0);
    [r2, c2] = find(corners2 > 0);
    
    % Get number of corners of each image
    n1 = length(r1);
    n2 = length(r2);
    
    % Convert images to double
    img1 = double(img1);
    img2 = double(img2);
    
    % Initialize data holder
    windows{1,1} = zeros(n1, 2);
    windows{2,1} = cell(n1, 1);    
    windows{1,2} = zeros(n2, 2);
    windows{2,2} = cell(n2, 1);

    % Get the window around each corner in img1
    for ii = 1:n1

        u = r1(ii);
        v = c1(ii);

        windows{1,1}(ii,:) = [u, v];

        % Ignore corners that make the window go out of bounds
        if u <= win || u >= size(img1, 1) - win
            windows{2,1}{ii} = [];
            continue;
        end
        if v <= win || v >= size(img1, 2) - win
            windows{2,1}{ii} = [];
            continue;
        end
        
        % Extract window and normalize
        w = img1((u - win):(u + win),(v - win):(v + win));
        windows{2,1}{ii} = w ./ sqrt(sum(w(:).^2));

    end

    % Get the window around each corner in img2
    for ii = 1:n2

        u = r2(ii);
        v = c2(ii);

        windows{1,2}(ii,:) = [u, v];

        % Ignore corners that make the window go out of bounds
        if u <= win || u >= size(img2, 1) - win
            windows{2,2}{ii} = [];
            continue;
        end
        if v <= win || v >= size(img2, 2) - win
            windows{2,2}{ii} = [];
            continue;
        end

        % Extract window and normalize
        w = img2((u - win):(u + win),(v - win):(v + win));
        windows{2,2}{ii} = w ./ sqrt(sum(w(:).^2));

    end

    % Scores is [r1, c1, r2, c2, NCC score]
    %  r2 and c2 correspond to the corner in img2 which 
    %  had the highest NCC score with the corner at r1, c1 in img1
    scores = zeros(n1, 5);

    % For each corner in img1
    for ii = 1:n1
        
        percent = 100 * ii / n1;
        if mod(percent, 10) == 0
            disp(percent)
        end

        scores(ii,1) = windows{1,1}(ii,1);
        scores(ii,2) = windows{1,1}(ii,2);
        scores(ii,3) = windows{1,2}(1,1);
        scores(ii,4) = windows{1,2}(1,2);
        scores(ii,5) = -1;

        % Skip windows that go out of bounds
        if isempty(windows{2,1}{ii})
            continue;
        end

        % For each corner in img2
        for jj = 1:n2
            
            % Skip windows that go out of bounds
            if isempty(windows{2,2}{jj})
                continue;
            end
         
            % Calculate NCC
            ncc = sum(sum(windows{2,1}{ii} .* windows{2,2}{jj}));
            
            % Keep the corner with the highest NCC
            if ncc > scores(ii,5)
                scores(ii,3) = windows{1,2}(jj,1);
                scores(ii,4) = windows{1,2}(jj,2);
                scores(ii,5) = ncc;
            end

        end

    end
    
    % Filter out bad scores
    scores = scores(scores(:,5) > -1, :);

end