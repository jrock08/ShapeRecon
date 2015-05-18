function feature = extractFeature( images, fixedCoords, matchCoords )
%EXTRACTFEATURE Extract random sampled silhouette feature from images

    feature = zeros(length(images), size(fixedCoords, 2) + size(matchCoords, 2));
    BACKGROUND = 255;
    
    for i = 1:size(images, 2)
        I = imread(images{i});
        [~, ~, dim] = size(I);
        if dim>1
            I  = rgb2gray(I);
        end
        I = cutImage(I);
        
        % Fixed coordinates
        iCoords = max(floor(fixedCoords.*size(I, 2)), 1);
        f = I(sub2ind(size(I), iCoords(1, :), iCoords(2, :))) ~= BACKGROUND;
        feature(i, 1:size(fixedCoords, 2)) = f';
        
        % Matching coordinates
        iCoords = max(floor(matchCoords.*size(I, 2)), 1);
        f = I(sub2ind(size(I), iCoords(1, :), iCoords(2, :))) < ...
            I(sub2ind(size(I), iCoords(3, :), iCoords(4, :)));
        feature(i, (size(fixedCoords, 2) + 1):end) = f';
    end    
end

