function plotStats(matches, statName, stat, percent)

    close all;
    [~, i] = sort(stat);
    count = floor(length(stat)*percent);
    
    fig = figure; 
    scatter(stat(i), matches.silhouetteIOU(i), 5, 'filled');
    title([statName ' vs Silhouette IOU']);
    saveas(fig, 'SilhouetteIOU.png');
    
    fig = figure;
    [x, y] = bucket(i, stat, matches.silhouetteIOU, count);
    scatter(x,y,5,'filled');
    title([statName ' vs Silhouette IOU']);
    saveas(fig, 'SilhouetteIOUBINNED.png');
    
    fig = figure; 
    scatter(stat(i), matches.silhouetteDistNorm(i), 5, 'filled');
    title([statName ' vs Silhouette Distance Normalized']);
    saveas(fig, 'SilhouetteDistanceNormalized.png');
    
    fig = figure;
    [x, y] = bucket(i, stat, matches.silhouetteDistNorm, count);
    scatter(x,y,5,'filled');
    title([statName ' vs Silhouette Distance Normalized']);
    saveas(fig, 'SilhouetteDistanceNormalizedBINNED.png');

    fig = figure; 
    scatter(stat(i), matches.IOU(i), 5, 'filled');
    title([statName ' vs Voxel IOU']);
    saveas(fig, 'VoxelIOU.png');
    
    fig = figure;
    [x, y] = bucket(i, stat, matches.IOU, count);
    scatter(x,y,5,'filled');
    title([statName ' vs Voxel IOU']);
    saveas(fig, 'VoxelIOUBINNED.png');

    fig = figure; 
    scatter(stat(i), matches.IOUdist_norm(i), 5, 'filled');
    title([statName ' vs Voxel Distance Normalized']);
    saveas(fig, 'VoxelDistanceNormalized.png');
    
    fig = figure;
    [x, y] = bucket(i, stat, matches.IOUdist_norm, count);
    scatter(x,y,5,'filled');
    title([statName ' vs Voxel Distance Normalized']);
    saveas(fig, 'VoxelDistanceNormalizedBINNED.png');

    fig = figure; 
    scatter(stat(i), matches.surfaceDist(i), 5, 'filled');
    title([statName ' vs Surface Distance']);
    saveas(fig, 'SurfaceDistance.png');
    
    fig = figure;
    [x, y] = bucket(i, stat, matches.surfaceDist, count);
    scatter(x,y,5,'filled');
    title([statName ' vs Surface Distance']);
    saveas(fig, 'SurfaceDistanceBINNED.png');

end

function [x, y] = bucket(idx, stat1, stat2, step)

x = [];
y = [];
for i = 1:step:length(idx)
    start = i;
    stop = min(length(idx), start+step-1);
    x(end+1) = mean(stat1(idx(start:stop)));
    y(end+1) = mean(stat2(idx(start:stop)));
end
end