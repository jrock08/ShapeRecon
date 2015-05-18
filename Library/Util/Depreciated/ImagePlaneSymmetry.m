function [ mesh ] = ImagePlaneSymmetry(depthmap, camera)
warning('Depreciated, use FrontalDepthmapMesh(depthmap) instead');
mesh = FrontalDepthmapMesh(depthmap);
end

