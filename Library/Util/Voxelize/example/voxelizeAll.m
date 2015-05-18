
mesh_root_dir = '~/Data/Meshes/mesh_aligned3/';
voxel_root_dir = '~/Data/Meshes/voxels_aligned3/';

mesh_name_loaded = 'XXX';
cam_count = 0;
for i = 1:numel(iminfo.camera)
    if (~strcmp(mesh_name_loaded, iminfo.meshes{i}))
        mesh = readMesh(iminfo.meshes{i});
        cam_count = 0;
        mesh_name_loaded = iminfo.meshes{i}
        mkdir([voxel_root_dir iminfo.names{i}]);
    end

    volume = voxelizeMesh(mesh, iminfo.camera{i});
    %[M, P, V] = getCamera(struct('camera', iminfo.camera{i}));
    %[~, ~, mesh_] = ApplyCamera(mesh, M', P, V);

    %FF.faces = mesh_.f';

    %min_coord = min(mesh_.v(:));
    %max_coord = max(mesh_.v(:));
    %range = max_coord - min_coord;
    %VOXEL_SCALE = 200;

    %FF.vertices = (mesh_.v(1:3,:)' - min_coord) * VOXEL_SCALE / range;

    %volume = polygon2voxel(FF, [1 1 1]*VOXEL_SCALE, 'none');

    voxel_name = [voxel_root_dir iminfo.names{i} '/view_' num2str(cam_count) '.mat'];
    save(voxel_name, 'volume');
    iminfo.voxel{i} = voxel_name;

    cam_count = cam_count + 1;
end
