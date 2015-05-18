function plotVoxelSurface(data, voxelIOU, surfaceDist, percent)

close all;

fig = figure;
hist(voxelIOU, 100);
title('Voxel I/U', 'FontSize', 20);
saveas(fig, 'voxel_unknownview.png');

fig = figure;
hist(surfaceDist, 100);
title('Surface Distance', 'FontSize', 20);
saveas(fig, 'surface_unknownview.png');

fig = figure;
[~, i] = sort(voxelIOU);
if(nargin > 3)
    count = floor(length(voxelIOU)*percent);
    [x, y] = bucket(i, voxelIOU, surfaceDist, count);
else
    x = voxelIOU(i);
    y = surfaceDist(i);
end
color = y < .05 | (x > .3 & y < .08) | (x > .5 & y < .12);
sum(color) / length(color)
color = color == 0;
scatter(x,y,20,color,'filled');
title('Voxel I/U vs Surface Distance', 'FontSize', 20);
saveas(fig, 'voxel_vs_surface_unknownview.png');

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