function [meshDeformed, deform_symmetryPts1, deform_symmetryPts2] = symDeformICP( pcl_query, pcl_match, mesh_match, mesh_match_simp )

warning('off','MATLAB:rankDeficientMatrix');
warning('off','MATLAB:illConditionedMatrix');

%% Add dependencies
% addpath(genpath('\symTPS'));

if(size(mesh_match.v,2)>10000)
	mesh = mesh_match_simp;
else
	mesh = mesh_match;
end

%% Find symmetry in the mesh
FV.vertices = mesh.v'/10;
FV.faces = mesh.f';

[clustCent, data2cluster, cluster2dataCell,...
    symPts1, symPts2] = symmetryPipeline_0_3(FV);
[symmetryPts1, symmetryPts2, sortedClusterCent] = genSymPts(clustCent,cluster2dataCell,FV);
symmetryPts1 = symmetryPts1*10;
symmetryPts2 = symmetryPts2*10;
FV.vertices = FV.vertices*10;
disp(['Found symmetry points: ' num2str(size(symmetryPts1,1))]);

%% Find correspondences
numCorr = 500;
[corr_match,corr_query] = findDeformationCorrespondences(pcl_match(1:3,:)...
                                                , pcl_query(1:3,:),1,numCorr/2);
disp(['Found correspondences: ' num2str(size(corr_match,1))]);

%% Show the point clouds
% figure, plot3(pcl_query(1,:),pcl_query(2,:),pcl_query(3,:),'r.',...
%     pcl_match(1,:),pcl_match(2,:),pcl_match(3,:),'b.');
% hold on;
% plot3([corr_match(:,1) corr_query(:,1)]',...
%     [corr_match(:,2) corr_query(:,2)]',...
%     [corr_match(:,3) corr_query(:,3)]','g-');
% hold off;

%% Sub-sample the symmetry points
numSymPts = size(symmetryPts1,1);
stride = ceil(numSymPts/500);
symmetryPts1_sub = symmetryPts1([1:stride:numSymPts],:);
symmetryPts2_sub = symmetryPts2([1:stride:numSymPts],:);

%% Generate control points on the surface of the mesh
[controlPts, chosenFaceIdx] = genSurfPts(mesh.v,mesh.f,numCorr);
% figure, plot3(mesh.v(1,:),mesh.v(2,:),mesh.v(3,:),'g.',...
%               controlPts(1,:),controlPts(2,:),controlPts(3,:),'r.');
% axis equal;        

%% Find the symmetry constrained TPS deformation
[L,par]= tpsSymPts(corr_match, corr_query,...
    symmetryPts1_sub, symmetryPts2_sub, controlPts');


disp(['Regressed TPS parameters with #symmetry points = ' ...
    num2str(size(symmetryPts1_sub,1))]);

%% Deform the match points
deform_match = tpsDeform(mesh_match.v, controlPts, par);
meshDeformed.f = mesh_match.f;
meshDeformed.v = deform_match';
disp('Deformed the matched point cloud');

%% Show the deformation results
% figure, plot3(pcl_query(1,:),pcl_query(2,:),pcl_query(3,:),'r.',...
%     pcl_match(1,:),pcl_match(2,:),pcl_match(3,:),'b.');
% hold on;
% trimesh(FV.faces,deform_match(:,1),deform_match(:,2),deform_match(:,3));
% 
% hold off;
% axis equal

% meshDeformed.f = mesh.f;
% meshDeformed.v = deform_match';

%% Get the mid point of symmetry points
midSym = (symmetryPts1 + symmetryPts2)/2;

%% Deform the symmetry points
deform_symmetryPts1 = tpsDeform(symmetryPts1',controlPts,par);
deform_symmetryPts2 = tpsDeform(symmetryPts2',controlPts,par);
end

