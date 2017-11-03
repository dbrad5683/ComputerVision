frame = 250;
filename = 'Office';
spatial_filter_names = {'identity', 'box3', 'box5', 'gauss1', 'gauss2', 'gauss3'};

for i = 1:6
    imshow(simple_temporal_masked{i}{frame})
    print([filename '_simple_' spatial_filter_names{i}], '-djpeg');
end

temporal_filter_names = {'tgauss1', 'tgauss2', 'tgauss3'};

for i = 1:6
    for j = 1:3
        imshow(gaussian_temporal_masked{i,j}{frame});
        print([filename '_' temporal_filter_names{j} '_' spatial_filter_names{i}], '-djpeg');
    end
end