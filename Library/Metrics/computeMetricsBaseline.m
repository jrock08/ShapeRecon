function matches = computeMetricsBaseline(matches, iminfo)
    tic;
    parfor i = 1:length(matches.testImages)
        fprintf('Match %d/%d\n', i, length(matches.testImages));
        query_info = queryIminfo(iminfo,matches.testImageObjName{i}, matches.testImageMeshNumber{i}, matches.testImageViewNumber{i});
        query_depth = query_info.depth;
        query_mesh = query_info.mesh;
        query_camera = query_info.camera;
        query_voxel = voxelizeMesh(query_mesh, query_camera);
        query_pcl = surfacePCLMesh(query_mesh, query_camera);

        % Jason's magic
        mesh_depth = ImagePlaneSymmetryVoxel(query_depth);
        [M,P,V] = getCamera(struct('camera', query_camera));
        mesh_depth.v = InvertCamera(mesh_depth.v, M, P, V);
        mesh_depth.v = mesh_depth.v(1:3,:);
        baseline_voxel = voxelizeMesh(mesh_depth, query_camera);
        baseline_pcl = surfacePCLMesh(mesh_depth, query_camera);

        voxelIOU(i) = VoxelIOUScore(query_voxel, baseline_voxel);
        surfaceDist(i) = surfDist(query_pcl, baseline_pcl);
    end
    matches.voxelIOU = voxelIOU;
    matches.surfaceDist = surfaceDist;
    toc;
end

function [voxelIOU, surfaceDist] = compute_metrics_error(query_depth, query_camera, query_mesh)
query_voxel = voxelizeMesh(query_mesh, query_camera);
query_pcl = surfacePCLMesh(query_mesh, query_camera);

% Jason's magic
mesh_depth = ImagePlaneSymmetryVoxel(query_depth);
[M,P,V] = getCamera(struct('camera', query_camera));
mesh_depth.v = InvertCamera(mesh_depth.v, M, P, V);
mesh_depth.v = mesh_depth.v(1:3,:);
baseline_voxel = voxelizeMesh(mesh_depth, query_camera);
baseline_pcl = surfacePCLMesh(mesh_depth, query_camera);

voxelIOU = VoxelIOUScore(query_voxel, baseline_voxel);
surfaceDist = surfDist(query_pcl, baseline_pcl);
end

