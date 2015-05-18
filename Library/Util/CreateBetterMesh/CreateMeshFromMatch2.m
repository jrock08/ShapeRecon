function [voxel_distance, voxel_sym, voxel_angle, voxel_defRot, voxel_similarity, not_exist_voxel, exist_voxel2] = CreateMeshFromMatch2(pcl_queryRot, pcl_symRef, mesh_defRot)
if(~isempty(pcl_symRef))
    [voxel_sym] = probabilityCarve_symmetry(pcl_symRef);
else
    voxel_sym = zeros(200,200,200);
end
[voxel_carve, voxel_distance, voxel_angle] = probabilityCarve(pcl_queryRot);

if(numel(mesh_defRot.f)/3 > 10000)
    mesh_defRot = simplifyMesh(mesh_defRot);
end
voxel_defRot = voxelizeMesh(mesh_defRot);

similarity_score = similarityFeature(pcl_queryRot,mesh_defRot);
voxel_similarity = similarity_score*ones(200,200,200);

not_exist_voxel = find(~voxel_carve);
exist_voxel = find(voxel_carve);

exist_voxel2 = find(~(~voxel_carve | voxel_distance > exp(-(4/100))));
end

