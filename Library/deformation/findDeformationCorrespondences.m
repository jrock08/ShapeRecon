function [corr1,corr2] = findCorrespondences(pts1, pts2, hop, numPairs)
% Finds two-way nearest neighbour correspondences between point clouds
% Input - 
% pts1 - 3 x #pts matrix of 3d point coordinates for 1st point cloud
% pts2 - 3 x #pts matrix of 3d point coordinates for 2nd point cloud
% hop - number of points to skip 
% numPairs - number of pairs to extract one-way
% Output - 
% corr1 - #correspondences x 3 matrix of matched points in 1st point cloud
% corr2 - #correspondences x 3 matrix of matched points in 2st point cloud
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Sub-sample
pcl1 = pts1(:,1:hop:size(pts1,2));
pcl2 = pts2(:,1:hop:size(pts2,2));

%% Select the points for which correspondences have to be found
index1 = randperm(size(pcl1,2),numPairs);
srcPCL1 = pts1(:,index1);

%% Select the points for which correspondences have to be found
index2 = randperm(size(pcl2,2),numPairs);
srcPCL2 = pts2(:,index2);

%% Create kd-trees for the two point clouds
kdTree1 = KDTreeSearcher(pcl1','Distance','euclidean','BucketSize',1);
kdTree2 = KDTreeSearcher(pcl2','Distance','euclidean','BucketSize',1);

%% Find nearest neighbours for each point in pcl1 from amongst pcl2
[idx2, d2]= knnsearch(kdTree2,srcPCL1');

%% Find nearest neighbours for each point in pcl2 from amongst pcl1
[idx1, d1]= knnsearch(kdTree1,srcPCL2');

%% Return the correspondences;
corr1 = [srcPCL1';pcl1(:,idx1)'];
corr2 = [pcl2(:,idx2)';srcPCL2'];
% corr1 = srcPCL1';
% corr2 = pcl2(:,idx2)';
end

