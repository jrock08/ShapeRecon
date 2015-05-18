function [X,Y] = getVoxelFeatAndLabelsInner(data,Neighbor)
c1.camera = data.camera_match;
[M_match,P_match,V_match]=getCamera(c1);

%% Apply camera

M_match(1:3,4) = 0;

[~,~,pcl_query_xformedRot_h] = ...
    ApplyCamera(data.pcl_query_xformed,M_match,P_match,V_match);
pcl_query_xformedRot = pcl_query_xformedRot_h(1:3,:);

if(isempty(data.pcl_symRef))
    pcl_symRefRot = [];
else
    [~,~,pcl_symRefRot_h] = ApplyCamera(data.pcl_symRef,M_match, ...
                                  P_match,V_match);
    pcl_symRefRot = pcl_symRefRot_h(1:3,:);
end

mesh_match_defRot.f = data.mesh_match_deformed.f;
[~,~,mesh_match_defRot_v_h] = ApplyCamera(data.mesh_match_deformed.v,M_match, ...
                                  P_match,V_match);
mesh_match_defRot.v = mesh_match_defRot_v_h(1:3,:);

mesh_query_worldRot.f = data.mesh_query_world.f;
[~,~,mesh_query_worldRot_v_h] = ApplyCamera(data.mesh_query_world.v,M_match, ...
                                  P_match,V_match);
mesh_query_worldRot.v = mesh_query_worldRot_v_h(1:3,:);

%% Voxelize and meshify  
[ voxel_unary, voxel_sym, voxel_binary,...
  voxel_defRot, voxel_similarity, not_exist_voxel,exist_voxel] = ...
CreateMeshFromMatch2(pcl_query_xformedRot, pcl_symRefRot, mesh_match_defRot);

X = [voxel_unary(exist_voxel) voxel_sym(exist_voxel)...
     voxel_binary(exist_voxel) voxel_defRot(exist_voxel)...
     voxel_similarity(exist_voxel)];
gt_voxel = voxelizeMesh(mesh_query_worldRot);
Y = gt_voxel(exist_voxel)*2-1;



