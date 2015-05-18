function [ pcl, d ] = depth2pclImage( depthMap, camera )
% Converts depthMap to point cloud
% Input -
% depthMap - an image where each pixel value is the depth
% camera - Opengl style camera, see GLCamera
% Output -
% pcl - #pts x 3 matrix of 3d coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warning('depth2pclImage Depreciated: use pclFromDepthCamera instead');

[pcl_, d_] = pclFromDepthCamera(depthMap, camera);
%% Get camera matrix

[M,P,V] = getCamera(camera);

%%
%[mesh_v, mesh_p, mesh_r] = ApplyCamera(mesh, M, P, V);

%% Get the point on the depth map
mask = depthMap~=255;
[I, J] = find(mask);

depth_d = double(depthMap(mask))/255.0;

d = depth_d;

% dmin = min(depth_d);
% dmax = max(depth_d);
% 
% d = (depth_d-dmin)/(dmax-dmin);

pts = [J, I, d];
% pts = zeros(size(I,1),3);
% for i=1:size(I,1)
%     pts(i,1:3)=[I(i) J(i) depthMap(I(i),J(i))];
% end


%% Invert the depth map to get the 3d coordinates
pcl = InvertCamera( pts', M, P, V );

assert(all(all(pcl(1:3,:)==pcl_)));
assert(all(d_==d));

end

