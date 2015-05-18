
voxel_root_dir = '~/Data/Meshes/voxels_aligned3/';

for i = 1:numel(iminfo.voxel)
  distance = zeros(numel(iminfo.voxel), 1);
  iminfo.voxel{i}
  voxel_1 = load(iminfo.voxel{i});
  for j = 1:numel(iminfo.voxel)
    voxel_2 = load(iminfo.voxel{j});
    distance(j) = VoxelIOUScore(voxel_1.volume, voxel_2.volume);
  end
  save([iminfo.voxel{i}(1:end-4) '_distance.mat'], 'distance');
end

