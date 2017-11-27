%% function pyramidReduce

function reduced = pyramidReduce(image, levels, sigma)
% image - image to be reduced
% levels - number of reductions including no reduction
% sigma - stddev of gaussian prefilter

    G = make2DGaussian(ceil(5 * sigma), sigma);
    
    reduced = cell(levels, 1);
    reduced{1} = image;
    
    for i = 2:levels
        reduced{i} = filter2(G, reduced{i - 1});
        reduced{i} = reduced{i}(1:2:end, 1:2:end);
    end
    
end