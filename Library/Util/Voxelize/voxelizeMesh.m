function [voxel] = voxelizeMesh(mesh, camera, voxelScale)
% This seems to be roughly the correct way to voxelize from a camera.  However,
% this ignores the projection and the viewport.
% TODO: Use projection and viewport.

if(nargin < 3)
    voxelScale = 200;
end

if(numel(mesh.v) == 0)
  voxel = false([1 1 1]*voxelScale);
  return
end

if( nargin < 2)
  mesh_ = mesh;
else
  [M, P, V] = getCamera(struct('camera', camera));

  % No translation, since we only care about how the object rotates.
  M(1:3,4) = 0;
  [~, ~, mesh_] = ApplyCamera(mesh, M, P, V);
end
FF.faces = mesh_.f';

% min_coord = min(mesh_.v(:));
% max_coord = max(mesh_.v(:));
% range = max_coord - min_coord;

FF.vertices = (mesh_.v(1:3,:)' + 2) * voxelScale / 4;

%FF.vertices = (mesh_.v(1:3,:)' - min_coord) * voxelScale / range;

voxel = polygon2voxel(FF, [1 1 1]*voxelScale, 'none');

end
