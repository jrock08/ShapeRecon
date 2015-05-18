function metrics = computeMetricsDeformed(meshes)
    tic;
    count = length(meshes);
    parfor i = 1:length(meshes)
        fprintf('Match %d/%d\n', i, count);
        query_mesh = meshes{i}.mesh_query_aligned;
        query_voxel = voxelizeMesh(query_mesh);
        query_pcl = surfacePCLMesh(query_mesh);

        [voxelIOU(i), surfaceDist(i)] = ...
            getMetrics(query_voxel, query_pcl, meshes{i}.mesh_match);

        [voxelIOUDeformed(i), surfaceDistDeformed(i)] = ...
            getMetrics(query_voxel, query_pcl, meshes{i}.mesh_match_deformed);

        [voxelIOUReconstructedSym(i), surfaceDistReconstructedSym(i)] = ...
            getMetrics(query_voxel, query_pcl, meshes{i}.mesh_reconstructed_wsym);

        [voxelIOUReconstructedNoSym(i), surfaceDistReconstructedNoSym(i)] = ...
            getMetrics(query_voxel, query_pcl, meshes{i}.mesh_reconstructed_wosym);
    end
    metrics.voxelIOU = voxelIOU;
    metrics.surfaceDist = surfaceDist;

    metrics.voxelIOUDeformed = voxelIOUDeformed;
    metrics.surfaceDistDeformed = surfaceDistDeformed;

    metrics.voxelIOUReconstructedSym = voxelIOUReconstructedSym;
    metrics.surfaceDistReconstructedSym = surfaceDistReconstructedSym;

    metrics.voxelIOUReconstructedNoSym = voxelIOUReconstructedNoSym;
    metrics.surfaceDistReconstructedNoSym = surfaceDistReconstructedNoSym;

    toc;
end

%%
function [voxelIOU, surfaceDist] = getMetrics(query_voxel, query_pcl, match_mesh)

 match_voxel = voxelizeMesh(match_mesh);
 match_pcl = surfacePCLMesh(match_mesh);

 voxelIOU = VoxelIOUScore(query_voxel, match_voxel);
 surfaceDist = surfDist(query_pcl, match_pcl);
end
