function [mesh] = voxelToMesh(voxel, max_num_faces)
if(nargin < 2)
  max_num_faces = 10000;
end

[ X,Y,Z,c] = voxelToIso( voxel==1 );
[F,V] = MarchingCubes(X,Y,Z,c,0);
mesh.f = F';
mesh.v = V';

mesh = simplifyMesh(mesh, max_num_faces);
end
