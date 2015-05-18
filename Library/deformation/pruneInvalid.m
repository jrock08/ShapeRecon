function [pcl_valid pcl_symRef]= pruneInvalid(pcl_query, pcl_sym)
% Input - 
% pcl_query - 3 x #numPts1 matrix of query point cloud
% pcl_sym - 3 x #numPts2 matrix of symmetry transfered point cloud
% Output - 
% pcl_valid - 3 x #numPts3 matrix of valid point clouds points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Add the (x,y) coordinates of each point in the pcl_query into a kd-tree
kdtree = KDTreeSearcher(pcl_query(1:2,:)','Distance','euclidean','BucketSize',50);

%% For every point in pcl_sym do a nn search on the above kd tree
[idx d] = knnsearch(kdtree,pcl_sym(1:2,:)');

%% Prune away happily
idx2select = find(pcl_sym(3,:)'<pcl_query(3,idx)');

%% Get the symmetry reflected part
pcl_symRef = pcl_sym(:,idx2select);
pcl_valid = [pcl_query pcl_symRef];

