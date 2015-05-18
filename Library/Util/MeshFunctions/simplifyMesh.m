function [ mesh ] = simplifyMesh(mesh, max_faces)
if(nargin < 2)
  max_faces = 10000;
end

mesh2 = reducepatch(struct('faces',mesh.f','vertices',mesh.v'),min(1,max_faces/(numel(mesh.f)/3)));
mesh = struct('f',mesh2.faces', 'v', mesh2.vertices');
end
