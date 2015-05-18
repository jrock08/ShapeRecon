function [X,Y,Z] = voxel_locations(voxel)

ind = find(voxel);
[X,Y,Z] = ind2sub(size(voxel), ind);

end
