function [ID1,ID2,d] = findAlignCorrespondences(srcPCL1, srcPCL2)
% Finds two-way nearest neighbour correspondences between point clouds
% Input - 
% srcPCL1 - 3 x #pts matrix of 3d point coordinates for 1st point cloud
% srcPCL2 - 3 x #pts matrix of 3d point coordinates for 2nd point cloud
% Output - 
% ID1 - #correspondences x 1 vector of matched point ids in 1st point cloud
% ID2 - #correspondences x 1 vector of matched point ids in 2st point cloud
% d - #correspondences x 1 vector of distances between the correspondences
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Select the points for which correspondences have to be found
srcPCL1Idx = [1:size(srcPCL1,2)]';

%% Select the points for which correspondences have to be found
srcPCL2Idx = [1:size(srcPCL2,2)]';

%% Create kd-trees for the two point clouds
kdTree1 = KDTreeSearcher(srcPCL1','Distance','euclidean','BucketSize',50);
kdTree2 = KDTreeSearcher(srcPCL2','Distance','euclidean','BucketSize',50);

%% Specify number of nearest neighbours for pruning based on distance ratios
K = 2; % Changed from 20

%% Find nearest neighbours for each point in srcPCL1 from amongst pcl2
[idx2, d2]= knnsearch(kdTree2,srcPCL1','K',K);

%% Select those points which have 1st best to Kth best distance ratio small
toTake1 = find((d2(:,1)./d2(:,K)) < 0.9); % Changed from 0.85


%% Find nearest neighbours for each point in pcl2 from amongst pcl1
[idx1, d1]= knnsearch(kdTree1,srcPCL2','K',K);

%% Select those points which have 1st best to Kth best distance ratio small
toTake2 = find((d1(:,1)./d1(:,K)) < 0.9); % Changed from 0.85

%% number of correspondence per point
perPt = 1;
% perPt = K;

%% Return the correspondence indices
ID1 = [repmat(srcPCL1Idx(toTake1,1),perPt,1);vec(idx1(toTake2,1:perPt))];
ID2 = [vec(idx2(toTake1,1:perPt));repmat(srcPCL2Idx(toTake2,1),perPt,1)];
d = [vec(d2(toTake1,1:perPt));vec(d1(toTake2,1:perPt))];
end

