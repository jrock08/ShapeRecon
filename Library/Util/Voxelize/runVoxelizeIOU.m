%matches = load('~/Data/Meshes/JunYoungMatching/matches_nonmax.mat') % from JunYoung
matches = load('/home/jrock/Data/Meshes/2014/DataJustDepth/VoxelForestMatching/match_3d_maxleaf5_p37');
load('/home/jrock/Data/Meshes/2014/DataJustDepth/Data/UnknownClass/iminfo');

for i = 1:length(matches.trainImages)
  [~, matches.trainImagesObjName{i}, matches.trainImageMeshNumber{i}, matches.trainImageViewNumber{i}] = parsePath(matches.trainImages{i});
end

for i = 1:length(matches.testImages)
  [~, matches.testImagesObjName{i}, matches.testImageMeshNumber{i}, matches.testImageViewNumber{i}] = parsePath(matches.testImages{i});
end

for i = 1:length(iminfo.images)
  [~, iminfo.objName{i}, iminfo.meshNumber{i}, iminfo.viewNumber{i}] = parsePath(iminfo.images{i});
end

[IOU, IOUdist, surface_dist] = VoxelizeIOU(matches, iminfo);

save('/home/jrock/Data/Meshes/2014/DataJustDepth/VoxelForestMatching/IOU_3d_maxleaf5_p37', 'IOU', 'IOUdist');
