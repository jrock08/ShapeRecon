function [symPts1,symPts2,sortedClusterCent] = genSymPts(clustCent,cluster2dataCell,FV)
%GENSYMPTS Summary of this function goes here
%   Detailed explanation goes here

% Sort the cluster centers according to significance
clusterSizes = zeros(size(cluster2dataCell,1),1);
for j=1:size(cluster2dataCell,1)
    clusterSizes(j,1) = size(cluster2dataCell{j,1},2);
end
[sortedSized, clustCentIdx] = sort(clusterSizes,'descend');
sortedClusterCent = clustCent(:,clustCentIdx);

%% Sample points on the mesh
numSurfPts = 30000;
[uniformSurfPts, chosenFaceIdx] = genSurfPts(FV.vertices',FV.faces',numSurfPts);


%% create a kdtree from uniformSurfPts
kdtree = KDTreeSearcher(uniformSurfPts','Distance','euclidean','BucketSize',1);

%% Check whether points satisfy reflection planes
numPlanes = size(sortedClusterCent,2);
if(numPlanes>10)
    numPlanes = 10;
end
% numPlanes = 10;
symPtsTmp1 = [];
symPtsTmp2 = [];
distance = [];
for i=1:numPlanes
    
    %% Get plane normal and a point on the plane
    Tform = sortedClusterCent(:,i);
    ptsNormPlane = genPtsPlane(Tform(1),Tform(2),Tform(3));
    point = mean(ptsNormPlane)';
    n = [sortedClusterCent(1:2,i);...
        sqrt(1-norm(sortedClusterCent(1:2,i))^2)];
    A = eye(3) - 2*n*n';
    t = 2*n*n'*point;
    

    %% Project the surface points across the plane
    reflectedPts = (A*uniformSurfPts)+repmat(t,1,size(uniformSurfPts,2));
    
    %% Get nearest neighbour from the kdtree
    [idx dist] = knnsearch(kdtree,reflectedPts');
    
    %% Find the indices of points whose NN distances are small
    distIndices = find(dist < 0.001);
    symPtsTmp1 = [symPtsTmp1; uniformSurfPts(:,distIndices)'];
    symPtsTmp2 = [symPtsTmp2; uniformSurfPts(:,idx(distIndices))'];
    distance = [distance; dist(distIndices,1)];
    
end
if(size(distance,1)>10000)
   [sortedDistances, index] =sort(distance,'ascend');
   symPts1 = symPtsTmp1(index(1:10000),:);
   symPts2 = symPtsTmp2(index(1:10000),:);
else
  symPts1 = symPtsTmp1;
  symPts2 = symPtsTmp2;
end


end

