function [voxel_unary ] = probabilityCarve_symmetry( pcl )
%This scaling is unsafe
pcl_scaled = (pcl+2)*200/4;

depthmap = createFakeDepthIm(pcl_scaled);

[vx, vy, vz] = meshgrid(1:200,1:200,1:200);

dval_stack = repmat(depthmap,[1,1,200]);

dval_stack(isnan(dval_stack)) = 200;

voxel_carve = dval_stack < vz;
voxel_unary = voxel_carve.*exp((-((vz-dval_stack)/10).^2));

end

