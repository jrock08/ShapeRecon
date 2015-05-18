function generateImage(meshes,matches,iminfo, path_to_image_dir,skip)

%% Don't forget to Load Matches
mkdir(path_to_image_dir);        

numMeshes = numel(meshes);

for i=1:skip:numMeshes
%   try
    c.camera = meshes{i}.camera_match;
    [M, P, V] = getCamera(c);
    T = M(1:3,1:3);

    dirpath = [ path_to_image_dir '/'];

    %% query depthmap
    match_query = queryIminfo(iminfo, matches.testImageObjName{i}, matches.testImageMeshNumber{i}, matches.testImageViewNumber{i});
    depthmap_query = match_query.depth;%imread(matches.testImages{i});
       

    %% ground truth query mesh
    mesh_query = meshes{i}.mesh_query_aligned;
    mesh_query.v = T*mesh_query.v;
    
    
    

    %% Depth Mesh 
    h3 = figure('visible','off');
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
    
    %% Print Depthmap once        
    h1 = figure('visible','off')
    imshow(depthmap_query);
    saveTightFigure(h1,[dirpath  num2str(i) '_input_depth'] ...
                        ,'-dpng','-r500');
                    
    %% Print All Meshes rendered from a particular view point     
    %    xRotTable = [0 0 90]; yRotTable = [0 90 -90];
    xRotTable = [0]; yRotTable = [0];
    for viewNum = 1:size(xRotTable,2)
        xRot = xRotTable(viewNum); yRot = yRotTable(viewNum); 
        h2 = figure('visible','off')
        displayMesh2(mesh_query);
        view(2);
        camorbit(gca,xRot,yRot);
        saveTightFigure(h2,[dirpath num2str(i) '_query_ground_truth_' ...
                            num2str(viewNum)],'-dpng','-r500');
        h5 = figure('visible','off')
        displayMesh2(mesh_match);
        view(2);
        camorbit(gca,xRot,yRot);
        saveTightFigure(h5,[dirpath num2str(i) '_matched_exemplar_' ...
                            num2str(viewNum)],'-dpng','-r500');
        h6 = figure('visible','off')
        displayMesh2(mesh_match_deformed);
        view(2);
        camorbit(gca,xRot,yRot);
        saveTightFigure(h6,[dirpath num2str(i) '_deformed_exemplar_' ...
                            num2str(viewNum)],'-dpng','-r500');
        h7 = figure('visible','off')
        displayMesh2(mesh_reconstructed_from_depthmap);
        view(2);
        camorbit(gca,xRot,yRot);
        saveTightFigure(h7,[dirpath num2str(i) '_reconstruction_from_depth_' ...
                            num2str(viewNum)],'-dpng','-r500');
        h8 = figure('visible','off')
        displayMesh2(mesh_reconstructed_from_depth_match);  
        view(2)
        camorbit(gca,xRot,yRot);
        saveTightFigure(h8,[dirpath num2str(i) '_reconstruction_from_exemplar_' ...
                            num2str(viewNum)],'-dpng','-r500');

        close all
    end
       
%  catch
%       disp([ num2str(i) ' not saved because of our super
%       production quality code :p ' ])
%  end
end