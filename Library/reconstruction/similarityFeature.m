function [ similarity_score ] = similarityFeature(pcl_query, mesh)
% Input:
% pcl_query = 3 x #numQueryPts matrix of points in the query point cloud
% mesh = {mesh.v,mesh.f}
% Output:
% similarity_score - rms distance of one way distance between
% pcl_query points and their corresponding nearest neighbours in
% mesh

mesh = samplePointsInMesh(mesh);
kdTree = KDTreeSearcher(mesh.v_sample','Distance','euclidean', ...
                        'BucketSize',1);
[~, d] = knnsearch(kdTree,pcl_query');
N = size(d,1);
similarity_score = sqrt((norm(d,2)^2)/N);

end 
