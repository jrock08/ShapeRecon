function [ X,Y,Z,c] = voxelToIso( voxel )

outer = -bwdist(voxel);
inner = bwdist(~voxel);

c = outer;
c(voxel) = inner(voxel);
[X,Y,Z] = meshgrid(1:size(voxel,2), 1:size(voxel,1), 1:size(voxel,3));

end

