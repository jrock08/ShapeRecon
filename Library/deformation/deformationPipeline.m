function deformation_data = deformationPipeline(key,depth_query,mesh_query,depth_match,mesh_match,mesh_match_simp,camera_query,camera_match)
%% Input - 
%% key - struct which contains a unique id for every query-match pair
%% depth_query - query depth image
%% mesh_query - query mesh, a struct with {f,v} each is a 3 x
%% #faces/#vertices matrix
%% depth_match - match depth image
%% mesh_match - match mesh, a struct with {f,v} each is a 3 x
%% #faces/#vertices matrix
%% camera - contains the camera used to invert the depthmap to the frame
  %% of reference of the match_mesh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    rng(103801);
    
    %% Invert the depth maps to get 2.5D point clouds
    [pcl_q] = pclFromDepthCamera(depth_query, struct('camera', camera_match));
    [pcl_m] = pclFromDepthCamera(depth_match, struct('camera', camera_match));
    pcl_query = pcl_q(1:3,:);
    pcl_match = pcl_m(1:3,:);
     
    %% Coarsely align the point clouds and the meshes using spin correspondences 
    %% and spectral matching
    [pcl_query_xformed,s,R,t] = coarseAlign(pcl_match, pcl_query);
    disp('Done coarse alignment');
    
    %% Deform the point cloud
    [mesh_match_deformed, deform_symmetryPts1, deform_symmetryPts2] = symDeformICP( pcl_query_xformed, pcl_match, mesh_match, mesh_match_simp);
    disp('Deformed the point cloud');

    %% Transfer symmetry
    pcl_symXfered = transferSym(pcl_query_xformed, deform_symmetryPts1, deform_symmetryPts2);
    disp('Transfered the symmetries');

    %% Rotate back
    c1.camera = camera_match;
    [M_match,P_match,V_match]=getCamera(c1);
    c2.camera = camera_query;
    [M_query,P_query,V_query]=getCamera(c2);

    [~,~,pcl_symXRot_homogeneous] = ApplyCamera(pcl_symXfered,M_match,P_match,V_match);
    if(isempty(pcl_symXRot_homogeneous))
      pcl_symXRot = [];
    else
      pcl_symXRot = pcl_symXRot_homogeneous(1:3,:);
    end
    [~,~,pcl_query_xformedRot_homogeneous] = ApplyCamera(pcl_query_xformed,M_match,P_match,V_match);
    pcl_query_xformedRot = pcl_query_xformedRot_homogeneous(1:3,:);
    [~,~,mesh_match_defRot_homogeneous] = ApplyCamera(mesh_match_deformed,M_match,P_match,V_match);
    mesh_match_defRot.f = mesh_match_defRot_homogeneous.f;
    mesh_match_defRot.v = mesh_match_defRot_homogeneous.v(1:3,:);
    disp('Transformed to viewing direction');
    
    %% Prune invalid points
    if(isempty(pcl_symXRot))
      pcl_symRefRot = [];
    else
      [~, pcl_symRefRot]= pruneInvalid(pcl_query_xformedRot, pcl_symXRot);
      disp('Pruned invalid points');
    end

    %% Culling
    pcl_backfacing = extendPcl(pcl_query_xformedRot,mesh_match_defRot);
    disp('Done front face culling');

    [~, pcl_completeRot] = pruneInvalid(pcl_query_xformedRot,pcl_backfacing);

    %% Rotate everything back into the frame of meshes
    if(~isempty(pcl_symRefRot))
      pcl_symRef_world_homogeneous = M_match\[pcl_symRefRot; ones(1,size(pcl_symRefRot,2))];
      pcl_symRef_world = pcl_symRef_world_homogeneous(1:3,:);
    else
      pcl_symRef_world_homogeneous = [];
      pcl_symRef_world = [];
    end
    pcl_complete_world_homogeneous = M_match\[pcl_completeRot; ones(1,size(pcl_completeRot,2))];
    pcl_complete_world = pcl_complete_world_homogeneous(1:3,:);
    
    %% Get query mesh in the same frame of reference
    % Step 1: Apply camera of query
    [mesh_query_camera_homogeneous,~,~] = ApplyCamera(mesh_query,M_query,P_query,V_query);
    mesh_query_camera.f = mesh_query_camera_homogeneous.f;
    mesh_query_camera.v = mesh_query_camera_homogeneous.v(1:3,:);
    % Step 2: Invert Camera of match
    mesh_query_not_aligned.f = mesh_query_camera.f; 
    mesh_query_not_aligned_v_homogeneous = InvertCamera([mesh_query_camera.v; ones(1,size(mesh_query_camera.v,2))],M_match,P_match,V_match); 
    mesh_query_not_aligned.v = mesh_query_not_aligned_v_homogeneous(1:3,:);
    % Align this mesh
    mesh_query_world.f = mesh_query_camera.f;
    mesh_query_world.v = s*R*mesh_query_not_aligned.v + repmat(t,1,size(mesh_query_not_aligned.v,2));
    
    %% Write everything to a data structure for return
    deformation_data.key = key;
    deformation_data.mesh_query = mesh_query;
    deformation_data.mesh_query_world = mesh_query_world;
    deformation_data.mesh_match = mesh_match;
    %deformation_data.mesh_match_simp = mesh_match_simp;
    deformation_data.mesh_match_deformed = mesh_match_deformed;
    %deformation_data.pcl_query = pcl_query;
    %deformation_data.pcl_match = pcl_match;
    deformation_data.pcl_query_xformed = pcl_query_xformed;
    deformation_data.pcl_symRef = pcl_symRef_world;
    %deformation_data.pcl_extended = pcl_complete_world;
    deformation_data.camera_query = camera_query;
    deformation_data.camera_match = camera_match;	
    deformation_data.coarse_s = s;
    deformation_data.coarse_R = R;
    deformation_data.coarse_t = t;
    disp('Written into data structure ');
