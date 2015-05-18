function [ Mesh ] = readMesh( filename )
%READMESH reads the mesh identified by filename
% Mesh has v,f and optionally I (manually labeled points)
if(strcmp(filename(end-2:end), 'vtk'))
    [v,f] = readVtk2(filename);
else
    [v,f] = read_mesh(filename);
end
Mesh.v = v;
Mesh.f = f;
points_file = [ filename(1:end-4) '_points.mat'];
if(exist(points_file,'file'))
    load(points_file);
    Mesh.I = points;
else


end

