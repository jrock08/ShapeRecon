function [pcl, depth] = pclFromDepthCamera(depth, camera)
% Converts depth to point cloud
% Input: depth - a depth image
%        camera - the camera to project the 2.5D points
% Output -
% pcl - 3x#pts matrix of 3d coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get camera matrix
[M,P,V] = getCamera(camera);

%% Get the point on the depth map
mask = depth~=255;
[I, J] = find(mask);

depth = double(depth(mask))/255.0;

pts = [J, I, depth];

%% Invert the depth map to get the 3d coordinates
pcl = InvertCamera( pts', M, P, V );
pcl = pcl(1:3,:);
    
