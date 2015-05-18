function [ mesh ] = FrontalDepthmapMesh(depthmap)
depthmap_mask = depthmap~=255;
[mesh.f, xidx, yidx] = MeshFromDepthMap(depthmap_mask, depthmap);
pcl = pclFromDepthOnly(depthmap);
mesh.v = pcl(1:3,:);
end

