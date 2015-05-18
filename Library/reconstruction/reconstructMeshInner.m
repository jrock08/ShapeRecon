function [mesh_1,mesh_2] = reconstructMeshInner(data,Neighbor,voxel_classifier,depth_dist)
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

%% Voxelize and meshify

[ ~,mesh] = ...
   CreateMeshFromMatch(pcl_query_xformedRot, pcl_symRefRot, ...
                       mesh_match_defRot, Neighbor, voxel_classifier, ...
                       depth_dist);

mesh_1 = mesh{1};
if(numel(mesh_1.v) ~= 0)
  mesh_1.v = M_match(1:3,1:3)\mesh_1.v;
else
  error('mesh_1 has no vertices');
end
mesh_2 = mesh{2};
if(numel(mesh_2.v) ~= 0)
  mesh_2.v = M_match(1:3,1:3)\mesh_2.v;
else
  error('mesh_1 has no vertices');
end
end
