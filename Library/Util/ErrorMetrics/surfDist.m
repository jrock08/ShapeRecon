function [ rmsDist ] = surfDist( queryPCL, matchPCL )
% Input -
% queryPCL - 3 x #numQueryPts matrix of points in the query point cloud
% matchPCL - 3 x #numMatchPts matrix of points in the matched point cloud
% Output -
% dist - 1 x (#numQueryPts + #numMatchPts) array of distances between
% two way nearest neighbour correspondences
% rmsDist - root mean square distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Find nearest neighbour correspondences
[~,~,d] = findCorrespondencesSurfDist(queryPCL, matchPCL);
d = d/4;

%% Find root-mean square error
N = size(d,1);
rmsDist = sqrt((norm(d,2)^2)/N);
end

function [corr1,corr2,d] = findCorrespondencesSurfDist(pts1, pts2)
% Finds two-way nearest neighbour correspondences between point clouds
% Input - 
% pts1 - 3 x #pts matrix of 3d point coordinates for 1st point cloud
% pts2 - 3 x #pts matrix of 3d point coordinates for 2nd point cloud
% Output - 
% corr1 - #correspondences x 3 matrix of matched points in 1st point cloud
% corr2 - #correspondences x 3 matrix of matched points in 2st point cloud
% d - #correspondences x 1 array of distances between correspondences
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Select the points for which correspondences have to be found
srcPCL1 = pts1;

%% Select the points for which correspondences have to be found
srcPCL2 = pts2;

%% Create kd-trees for the two point clouds
kdTree1 = KDTreeSearcher(pts1','Distance','euclidean','BucketSize',1);
kdTree2 = KDTreeSearcher(pts2','Distance','euclidean','BucketSize',1);

%% Find nearest neighbours for each point in pcl1 from amongst pcl2
[idx2, d2]= knnsearch(kdTree2,srcPCL1');

%% Find nearest neighbours for each point in pcl2 from amongst pcl1
[idx1, d1]= knnsearch(kdTree1,srcPCL2');

%% Return the correspondences;
corr1 = [srcPCL1';pts1(:,idx1)'];
corr2 = [pts2(:,idx2)';srcPCL2'];

d = [d2;d1];
end


