function [ pcl ] = pclFromDepthOnly( depthImage)
% Only computes the PCL from the camera intrinsics.

V = [0,0,size(depthImage,1),size(depthImage,2)];
mask = depthImage~=255;
[I, J] = find(mask);

depth_d = double(depthImage(mask))/255.0;

d = depth_d;

pts = [J, I, d];
pcl = pts';

end

