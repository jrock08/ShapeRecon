function generateVideo(meshes,matches,iminfo,path_to_video_dir,skip)

%% Don't forget to Load Matches
mkdir(path_to_video_dir); 

tmpName = [path_to_video_dir '/tmp2'];
mkdir(tmpName);       

numMeshes = numel(meshes)
for i=1:skip:numMeshes
%   try
    c.camera = meshes{i}.camera_match;
    [M, P, V] = getCamera(c);
    T = eye(3);
%     T = M(1:3,1:3);

    dirpath = path_to_video_dir;

    %% query depthmap
    match_query = queryIminfo(iminfo, matches.testImageObjName{i}, matches.testImageMeshNumber{i}, matches.testImageViewNumber{i});
    depthmap_query = match_query.depth;%imread(matches.testImages{i}); 
       

    %% ground truth query mesh
    mesh_query = meshes{i}.mesh_query_aligned;
    mesh_query.v = T*mesh_query.v;
    

    %% Depth Mesh 
    mesh_depthmap = ImagePlaneSymmetryVoxel(depthmap_query); %
                                                             % Baseline
    mesh_depthmap.v = InvertCamera(mesh_depthmap.v, M, P, V);

    mesh_sym_plane = mesh_depthmap.sym_plane;
    mesh_sym_plane.v = InvertCamera(mesh_sym_plane.v, M, P, V);

    mesh_front_depthmap = ImagePlaneSymmetry(depthmap_query, c); % pcl to mesh
    mesh_front_depthmap.v = InvertCamera(mesh_front_depthmap.v, M, ...
                                             P, V);
    s = meshes{i}.coarse_s;
    R = meshes{i}.coarse_R;
    t = meshes{i}.coarse_t;
    mesh_depthmap_aligned.f = mesh_depthmap.f;
    mesh_depthmap_aligned.v = s*R*mesh_depthmap.v(1:3,:) + ...
        repmat(t,1,size(mesh_depthmap.v,2));

    mesh_front_depthmap_aligned.f = mesh_front_depthmap.f;
    mesh_front_depthmap_aligned.v = T*(s*R*mesh_front_depthmap.v(1:3,:) ...
                                       ...
        + repmat(t,1,size(mesh_front_depthmap.v,2)));
        %     displayMesh2(mesh_front_depthmap_aligned);
        %     title('Depth mesh','FontSize',3)
    

    %% Baseline
    mesh_depthmap_aligned.v = T*mesh_depthmap_aligned.v;
    %     displayMesh2(mesh_depthmap_aligned);
   
    %% Match mesh
    mesh_match = meshes{i}.mesh_match;
    mesh_match.v = T*mesh_match.v;
         

    %% Deformed Mesh
    mesh_match_deformed = meshes{i}.mesh_match_deformed;
    mesh_match_deformed.v = T*mesh_match_deformed.v;
       

    %% Reconstruction without symmetry
    mesh_reconstructed_from_depthmap = ...
        meshes{i}.mesh_reconstructed_wosym;
    mesh_reconstructed_from_depthmap.v = T* ...
        mesh_reconstructed_from_depthmap.v;
    
    
    %% Our Method
    mesh_reconstructed_from_depth_match = ...
        meshes{i}.mesh_reconstructed_wsym;
    mesh_reconstructed_from_depth_match.v = T* ...
        mesh_reconstructed_from_depth_match.v;
    
                   
    %% Print All Meshes rendered from a particular view point     
    createAnimation(mesh_query,50,[dirpath num2str(i) ...
                        '_query_ground_truth'],tmpName);
    createAnimation(mesh_match,50,[dirpath num2str(i) ...
                        '_match_mesh'],tmpName);
    createAnimation(mesh_match_deformed,50,[dirpath num2str(i) ...
                        '_deformed_mesh'],tmpName);
    createAnimation(mesh_reconstructed_from_depthmap,50,[dirpath ...
                        num2str(i) '_reconstruction_from_depth'],tmpName);
    createAnimation(mesh_reconstructed_from_depth_match,50,[dirpath ...
                        num2str(i) '_reconstruction_from_exemplar'],tmpName);       

%  catch
%       disp([ num2str(i) ' not saved because of our super
%       production quality code :p ' ])
%  end
end