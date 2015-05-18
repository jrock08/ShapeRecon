function [ cam_edges ] = ReadRenderedMesh( root_dir, mesh_id )
if isnumeric(mesh_id)
    mesh_id = ['D' sprintf('%05d', mesh_id)];
end

% If an output mesh doesn't exist, we should probably just give up.
mesh_name = [root_dir '/' mesh_id '_out.off'];
if ~exist(mesh_name,'file')
    error(['mesh with id ' mesh_id ' not found in ' rood_dir]);
end
mesh = readMesh(mesh_name);

temp_edges = readFile([root_dir '/' mesh_id '.off_out.txt']);
cam_edges.v = temp_edges;
cam_edges.mesh = mesh;

images = {};
for i = 1:length(cam_edges.v)
    cam_edges.v{i}.images = ReadImageStruct(root_dir, mesh_id, i-1, 0);
end

end

