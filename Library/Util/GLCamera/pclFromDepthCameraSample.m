function pcl = pclFromDepthCameraSample(depth, mask, camera)
% Converts depth to point cloud
% Input: depth - a depth image
%        camera - the camera to project the 2.5D points
% Output -
% pcl - 3x#pts matrix of 3d coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get the points on the depth map
[I, J] = find(mask);

depth = double(depth(mask))/255.0;

pts = [J, I, depth];
idx = mod(J, 2) & mod(I, 2);
pts = pts(idx, :);

[M,P,V] = getCamera(struct('camera', camera));

%% Invert the depth map to get the 3d coordinates
pcl = InvertCamera( pts', M, P, V );
pcl = pcl(1:3,:);
