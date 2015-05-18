function [pcl] = surfacePCLMesh(mesh, camera)

if(nargin < 2)
    mesh_ = mesh;
else
    [M, P, V] = getCamera(struct('camera', camera));
    [~,~,mesh_] = ApplyCamera(mesh, M, P, V);
end

mesh_ = samplePointsInMesh(mesh_);
pcl = mesh_.v_sample;
end

