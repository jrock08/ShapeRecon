function [pcl2_xformed,s,R,t] = coarseAlign(pcl_match, pcl_query)

pcl1 = pcl_match(1:3,:);
pcl2 = pcl_query(1:3,:);

%% Select the point at which spin image has to be computed
N1=size(pcl1,2);
pcl1_sub = pcl1(:,randperm(N1,min(N1,5000)));
model1 = pcl1(:,randperm(N1,min(N1,50000)));


N2=size(pcl2,2);
pcl2_sub = pcl2(:,randperm(N2,min(N2,5000)));
model2 = pcl2(:,randperm(N2,min(N2,50000)));

spinImgs1 = compSpinImages(pcl1_sub', model1', 0.1, 16, 20);
spinImgs2 = compSpinImages(pcl2_sub', model2', 0.1, 16, 20);


%% Convert spin images to feature vectors
dim = size(spinImgs1,1) * size(spinImgs1,2);

numPts1 = size(spinImgs1,3);
spinFeat1 = zeros(dim,numPts1);
for i=1:numPts1
    spinFeat1(:,i) = vec(spinImgs1(:,:,i));
end

numPts2 = size(spinImgs2,3);
spinFeat2 = zeros(dim,numPts2);
for i=1:numPts2
    spinFeat2(:,i) = vec(spinImgs2(:,:,i));
end
disp('Finding Correspondences using Feature matching');

%% Find the correspondences
[ID1,ID2,d] = findAlignCorrespondences(spinFeat1, spinFeat2);

disp('Found Correspondences using Feature Matching');

%% Show the found correspondences
corr1 = pcl1_sub(:,ID1);
corr2 = pcl2_sub(:,ID2);

% figure,plot3(pcl1_sub(1,:), pcl1_sub(2,:), pcl1_sub(3,:),'r.',...
%     pcl2_sub(1,:), pcl2_sub(2,:), pcl2_sub(3,:),'b.');
% axis equal
% hold on, plot3([corr1(1,:)' corr2(1,:)']',...
%     [corr1(2,:)' corr2(2,:)']',...
%     [corr1(3,:)' corr2(3,:)']','g-');
% hold off

%% Sort and select the best correspondences
numSubCorr = floor(0.5*size(ID1,1));

%% Prune by distance
[distSorted, distIdx] = distancePrune(corr1, corr2);

subIdx1 = ID1(distIdx(1:numSubCorr));
subIdx2 = ID2(distIdx(1:numSubCorr));

corr1_sub = pcl1_sub(:,subIdx1);
corr2_sub = pcl2_sub(:,subIdx2);

% figure,plot3(pcl1_sub(1,:), pcl1_sub(2,:), pcl1_sub(3,:),'r.',...
%     pcl2_sub(1,:), pcl2_sub(2,:), pcl2_sub(3,:),'b.');
% axis equal
% hold on, plot3([corr1_sub(1,:)' corr2_sub(1,:)']',...
%     [corr1_sub(2,:)' corr2_sub(2,:)']',...
%     [corr1_sub(3,:)' corr2_sub(3,:)']','g-');
% hold off

disp('Done distance pruning');

%% spectral correspondence
dist = distSorted(1:numSubCorr);
[corrPruned1, corrPruned2] = spectralCorr(corr1_sub,corr2_sub,dist,subIdx1,subIdx2);

% figure,plot3(corr1(1,:), corr1(2,:), corr1(3,:),'r.',...
%     corr2(1,:), corr2(2,:), corr2(3,:),'b.');
% axis equal
% hold on, plot3([corrPruned1(1,:)' corrPruned2(1,:)']',...
%     [corrPruned1(2,:)' corrPruned2(2,:)']',...
%     [corrPruned1(3,:)' corrPruned2(3,:)']','g-');
% hold off

disp('Found Spectral Correspondences');

%% find similarity transform
% [s,R,t] = findSimilarityTransform(corrPruned1,corrPruned2);
[s,R,t] = findSimilarityTransform(corrPruned2,corrPruned1);


disp('Found similarity transform');

%% apply similarity transform
pcl2_xformed = s*R*pcl2 + repmat(t,1,size(pcl2,2));
% match_mesh_xformed.f = match_mesh.f;
% match_mesh_xformed.v = s*R*match_mesh.v + repmat(t,1,size(match_mesh.v,2));

% figure,plot3(pcl1_xformed(1,:), pcl1_xformed(2,:), pcl1_xformed(3,:),'b.',...
%     pcl2(1,:), pcl2(2,:), pcl2(3,:),'r.',...
%      match_mesh_xformed.v(1,:), match_mesh_xformed.v(2,:), match_mesh_xformed.v(3,:),'g.');
%  hold on
%  trimesh(match_mesh_xformed.f',match_mesh_xformed.v(1,:)',match_mesh_xformed.v(2,:)',match_mesh_xformed.v(3,:)');
%  hold off
% axis equal


