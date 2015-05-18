function [clustCent,data2cluster,cluster2dataCell,symmetryPts1, symmetryPts2] = symmetryPipeline_0_3(FV)
%% Returns a symmetry graph for a 3D triangular mesh
% Input:
% FV - structure with 2 matrices 
%      FV.faces - #faces x 3 matrix
%      FV.vertices - #vertices x 3 matrix
% Output:
% clustCent         - is locations of cluster centers (numDim x numClust)
% data2cluster      - for every data point which cluster it belongs to (numPts)
% cluster2dataCell  - for every cluster which points are in it (numClust)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set constants
N = size(FV.vertices,1);

%% Generate sample points
% [samplePts, chosenFaceIdx] = genSurfPts(FV.vertices', FV.faces', N);
samplePts = FV.vertices';

%% Compute normal for each vertex and face
[normal,normalf] = compute_normal(FV.vertices',FV.faces');

%% Get the principle curvature magnitudes and directions for the samplePts
[Kmin,Kmax,Dmin,Dmax] = prinCurv2(FV,samplePts');

%% Compute Signatures for each of the samplePts
signatures = [Kmin Kmax];
sigForPruning = abs(Kmin./Kmax);

%% Point Pruning, i.e discard pts with signatures greater than 0.75
prunedPtsIdx = find(sigForPruning<0.75);
prunedSamplePts = samplePts(:,prunedPtsIdx);
prunedSignatures = signatures(prunedPtsIdx,:);
prunedKmin = Kmin(prunedPtsIdx,1);
prunedKmax = Kmax(prunedPtsIdx,1);
prunedDmin = Dmin(prunedPtsIdx,:);
prunedDmax = Dmax(prunedPtsIdx,:);
prunedNormals = normal(:,prunedPtsIdx)';

%% Match points in the signature space
kdTreeSignatures = KDTreeSearcher(prunedSignatures,'Distance','euclidean','BucketSize',1);
idxPrunedSignatures = rangesearch(kdTreeSignatures,prunedSignatures,0.05,'Distance','euclidean');

% corrMatrix = zeros(size(idxPrunedSignatures,1));
% for i=1:size(idxPrunedSignatures,1)
%     for j=1:size(idxPrunedSignatures{i},2)
%         corrMatrix(i,idxPrunedSignatures{i}(1,j))=1;
%         corrMatrix(idxPrunedSignatures{i}(1,j),i)=1;
%     end
%     for j=1:i
%         corrMatrix(i,j)=0;
%     end
% end

corrMatrix = zeros(size(idxPrunedSignatures,1));
mask = triu(pdist2(prunedSignatures,prunedSignatures)+eye(size(prunedSignatures,1)) < 0.05);
corrMatrix(mask) = 1;

if(sum(sum(corrMatrix))>50000)
    corrMatrix = zeros(size(idxPrunedSignatures,1));
    mask = triu(pdist2(prunedSignatures,prunedSignatures)+eye(size(prunedSignatures,1)) < 0.00001);
    corrMatrix(mask) = 1;
end

sparseCorrMatrix = sparse(corrMatrix);
[ptIdx1, ptIdx2, val] = find(sparseCorrMatrix);

% figure, title('Point Matching');
% p1=prunedSamplePts(:,ptIdx1)'; p2=prunedSamplePts(:,ptIdx2)';  
% plot3(prunedSamplePts(1,:),prunedSamplePts(2,:),prunedSamplePts(3,:),'r.');
% axis equal; 
% hold on
% plot3([p1(:,1) p2(:,1)]',[p1(:,2) p2(:,2)]',[p1(:,3) p2(:,3)]','g-');
% hold off

%% Normal Pruning

nprunedPtsIdx = normalPruning(prunedNormals,ptIdx1,ptIdx2,prunedSamplePts');

%figure, title('Point Matching Normal Pruning');
p1=prunedSamplePts(:,ptIdx1(nprunedPtsIdx,1))'; p2=prunedSamplePts(:,ptIdx2(nprunedPtsIdx,1))';  
%plot3(prunedSamplePts(1,:),prunedSamplePts(2,:),prunedSamplePts(3,:),'r.');
%axis equal; 
%hold on
%plot3([p1(:,1) p2(:,1)]',[p1(:,2) p2(:,2)]',[p1(:,3) p2(:,3)]','b-');
%hold off
symmetryPts1 = p1;
symmetryPts2 = p2;

%% Map point to transformation space (parameter space of reflexive transfoms
% Iterate over all normal pruned pairs
transforms = zeros(size(nprunedPtsIdx,1),3);
for i = 1:size(nprunedPtsIdx,1)
    planeNormal = p1(i,:)-p2(i,:);
    planeNormal = planeNormal./norm(planeNormal,2);
    midPoint = (p1(i,:) + p2(i,:))/2;
    d = planeNormal*midPoint';
    transforms(i,:) = [planeNormal(1,1:2) d].*sign(planeNormal(1,3));
end

% figure, title('Transformation Space');
% plot3(transforms(:,1),transforms(:,2),transforms(:,3),'k.');
% axis equal;

%% Mean Shift clustering in transformation space
[clustCent,data2cluster,cluster2dataCell] = MeanShiftCluster(transforms',0.05,false);

% % Sort the cluster centers according to significance
% clusterSizes = zeros(size(cluster2dataCell,1),1);
% for j=1:size(cluster2dataCell,1)
%     clusterSizes(j,1) = size(cluster2dataCell{j,1},2);
% end
% [sortedSized, clustCentIdx] = sort(clusterSizes,'descend');
% sortedClusterCent = clustCent(:,clustCentIdx);

%% Draw the symmetry planes
% figure, trimesh(FV.faces,FV.vertices(:,1),FV.vertices(:,2),FV.vertices(:,3));
% axis equal;
% hold on
% for i=1:1
%     Tform = sortedClusterCent(:,i);
%     ptsNormPlane = genPtsPlane(Tform(1),Tform(2),Tform(3));
%     fill3(ptsNormPlane(:,1),ptsNormPlane(:,2),ptsNormPlane(:,3),'r');
% end
% hold off






