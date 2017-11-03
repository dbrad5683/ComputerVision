%% function estimateHomography

function [h, scores] = estimateHomography(scores, num_iterations)
% scores - output of normalizedCrossCorrelation
% threshold - euclidean distance threshold to classify as inlier
% num_iterations - number of iterations

    num_inliers = 0;
    
    for i = 1:num_iterations

        % Calculate the homography using 4 random corners
        idx = randi(size(scores, 1), 4, 1);
        h = calculateHomography(scores(idx,1:4));

        inliers = zeros(size(scores, 1), 1);
        
        % Calculate score of homography by comparing the observed (input)
        %  corner with the predicted corner calculated from the homography
        for ii = 1:size(scores, 1)

            % We have to convert from [row, col] to [x; y]
            observed = [scores(ii,4), scores(ii,3), 1]';
            predicted = h * [scores(ii,2), scores(ii,1), 1]';
            
            % Normalize
            predicted = predicted ./ predicted(3);

            % Calculate euclidean distance between observed and predicted
            diff = sqrt(sum((predicted - observed).^2));

            % Threshold 
            if diff < 1
                inliers(ii) = 1;
            end

        end

        % Keep the homography with the most inliers
        if sum(inliers) > num_inliers
            num_inliers = sum(inliers);
            best_inliers = inliers;
        end

    end
    
    scores = scores(best_inliers > 0, :);
    h = calculateHomography(scores(:, 1:4));

end