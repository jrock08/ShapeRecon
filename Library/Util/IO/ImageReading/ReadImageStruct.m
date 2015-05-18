function [ images ] = ReadImageStruct( imageDir, mesh_id, view_id, load_mesh )
if(nargin < 4)
    load_mesh = 0;
end
if isnumeric(mesh_id)
    mesh_id = ['D' sprintf('%05d', mesh_id)];
end
if isnumeric(view_id)
    view_id = ['v' num2str(view_id)];
end

% If an output mesh doesn't exist, we should probably just give up since
% it's pretty unlikely that the images are in the directory
mesh_name = [imageDir '/' mesh_id '_out.off'];
if ~exist(mesh_name,'file')
    error(['mesh with id ' mesh_id ' not found in ' imageDir]);
end

image_prefix = [imageDir '/' mesh_id '.off_' view_id];
% Check if there are images in the directory directly
d = dir([image_prefix '*.png']);
if(isempty(d))
    error(['images not found at ' image_prefix '*.png']);
end


% Load the mesh if we want to.
if(load_mesh)
    images.mesh = readMesh(mesh_name);
end
%Load all image informaiton
images.depth = double(imread([image_prefix '_depth.png']))/255.0;
images.fold = imread([image_prefix '_Fold Edges.png']);
images.hole = imread([image_prefix '_Hole Edges.png']);
images.occlusion = imread([image_prefix '_Occlusion Edges.png']);
images.fold_ext = imread([image_prefix '_exterior_Fold Edges.png']);
images.hole_ext = imread([image_prefix '_exterior_Hole Edges.png']);
images.occlusion_ext = imread([image_prefix '_exterior_Occlusion Edges.png']);

end

