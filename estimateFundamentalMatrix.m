%% function estimateFundamentalMatrix

function [f, scores] = estimateFundamentalMatrix(scores, num_iterations)
% scores - output of normalizedCrossCorrelation
% num_iterations - number of iterations

    num_inliers = 0;
    
    for i = 1:num_iterations

        % Calculate the fundamental matrix using 8 random corners
        idx = randi(size(scores, 1), 8, 1);
        f = calculateFundamentalMatrix(scores(idx,1:4));

        inliers = zeros(size(scores, 1), 1);
        
        % Calculate score of fundamental matrix by comparing the observed (input)
        %  corner with the predicted corner
        for ii = 1:size(scores, 1)

            % We have to convert from [row, col] to [x; y]
            observed = [scores(ii,4), scores(ii,3), 1];
            predicted = [scores(ii,2), scores(ii,1), 1];
            
            result = observed * f * predicted';

            % Calculate euclidean distance from 0
            diff = sqrt(sum(result.^2));

            % Threshold 
            if diff < 1e-8
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
    f = calculateFundamentalMatrix(scores(:, 1:4));

end