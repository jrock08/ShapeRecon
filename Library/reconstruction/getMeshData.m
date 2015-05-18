function [meshes] = getMeshData(data,Neighbor,voxel_classifier,depth_dist)

[mesh_reconstructed_wsym, mesh_reconstructed_wosym] = reconstructMeshInner(data,Neighbor,voxel_classifier,depth_dist);

mesh_query_not_aligned.f = data.mesh_query_world.f;
mesh_query_not_aligned_v_h = data.coarse_R\[(data.mesh_query_world.v -repmat(data.coarse_t,1,size(data.mesh_query_world.v,2)))]/data.coarse_s;
mesh_query_not_aligned.v = mesh_query_not_aligned_v_h(1:3,:);

meshes.mesh_query_not_aligned = mesh_query_not_aligned;
meshes.mesh_query_aligned = data.mesh_query_world;
meshes.mesh_match = data.mesh_match;
meshes.mesh_match_deformed = data.mesh_match_deformed;
meshes.mesh_reconstructed_wsym = mesh_reconstructed_wsym;
meshes.mesh_reconstructed_wosym = mesh_reconstructed_wosym;
meshes.pcl_query = data.pcl_query_xformed;
meshes.camera_query = data.camera_query;
meshes.camera_match = data.camera_match;	
meshes.coarse_s = data.coarse_s;
meshes.coarse_R = data.coarse_R;
meshes.coarse_t = data.coarse_t;
meshes.key = data.key;
