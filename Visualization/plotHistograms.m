function plotHistograms(matches)
    close all;
    
    fprintf('Silhouette IOU Mean: %f\n', mean(matches.silhouetteIOU));
    fprintf('Silhouette IOU Median: %f\n', median(matches.silhouetteIOU));
    fprintf('Silhouette Distance Mean: %f\n', mean(matches.silhouetteDist));
    fprintf('Silhouette Distance Median: %f\n', median(matches.silhouetteDist));
    fprintf('Silhouette Distance Normalized Mean: %f\n', mean(matches.silhouetteDistNorm));
    fprintf('Silhouette Distance Normalized Median: %f\n', median(matches.silhouetteDistNorm));
    fprintf('Voxel IOU Mean: %f\n', mean(matches.IOU));
    fprintf('Voxel IOU Median: %f\n', median(matches.IOU));
    fprintf('Voxel Distance Mean: %f\n', mean(matches.IOUdist));
    fprintf('Voxel Distance Median: %f\n', median(matches.IOUdist));
    fprintf('Voxel Distance Normalized Mean: %f\n', mean(matches.IOUdist_norm));
    fprintf('Voxel Distance Normalized Median: %f\n', median(matches.IOUdist_norm));
    fprintf('Surface Distance Mean: %f\n', mean(matches.surfaceDist));
    fprintf('Surface Distance Median: %f\n', median(matches.surfaceDist));
    
    fig = figure;
    hist(matches.silhouetteIOU, 100);
    title('Silhouette IOU');
    saveas(fig, 'SilhouetteIOU.png');
    
    fig = figure;
    hist(matches.silhouetteDistNorm, 100);
    title('Silhouette Distance Normalized');
    saveas(fig, 'SilhouetteDistanceNormalized.png');
    
    fig = figure;
    hist(matches.IOU, 100);
    title('Voxel IOU');
    saveas(fig, 'VoxelIOU.png');
    
    fig = figure;
    hist(matches.IOUdist_norm, 100);
    title('Voxel Distance Normalized');
    saveas(fig, 'VoxelDistanceNormalized.png');
    
    fig = figure;
    hist(matches.surfaceDist, 100);
    title('Surface Distance');
    saveas(fig, 'SurfaceDistance.png');
end


function ret = median(data)
    data = sort(data);
    i = length(data) / 2;
    if(i < 1)
       ret = data(1); 
    else
        ret = (data(floor(i)) + data(ceil(i))) / 2;
    end
end