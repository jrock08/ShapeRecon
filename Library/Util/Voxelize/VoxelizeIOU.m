function [IOU, IOUdist, surface_dist] = VoxelizeIOU(matches, iminfo)
% For each test image in the match, get the mesh, voxelize the mesh after applying the rotation from the best camera match.
% TODO: How does the projection and viewport affect the mesh alignment?

parfor i = 1:length(matches.testImages)
  [camera, mesh] = getMeshCamera(iminfo, matches.testImagesObjName{i}, matches.testImageMeshNumber{i}, matches.testImageViewNumber{i});
  voxel = voxelizeMesh(mesh, camera);
  [camera_match, mesh_match] = getMeshCamera(iminfo, ...
      matches.trainImagesObjName{matches.testImgIdx(i)}, ...
      matches.trainImageMeshNumber{matches.testImgIdx(i)}, ...
      matches.trainImageViewNumber{matches.testImgIdx(i)});
  voxel_match = voxelizeMesh(mesh_match, camera_match);
  IOU(i) = VoxelIOUScore(voxel, voxel_match);

  voxel_dist = bwdist(voxel);
  %voxel_dist(voxel_dist>10) = 10;
  IOUdist(i) = mean(voxel_dist(:).*voxel_match(:));

  surface_dist(i) = surfDist(surfacePCLMesh(mesh, camera), ...
      surfacePCLMesh(mesh_match, camera_match));
end

end

