function [ points ] = InvertCamera( points, rotation, perspective, viewport )
%INVERTCAMERA Summary of this function goes here
%   Detailed explanation goes here

A = perspective*rotation;
%(winx-(float)viewport[0])/(float)viewport[2]*2.0-1.0;
points(1,:) = (points(1,:)-viewport(1))/viewport(3)*2-1;
points(2,:) = -(points(2,:)-viewport(2))/viewport(4)*2+1;
points(3,:) = 2*points(3,:)-1;
points(4,:) = 1;
points = A\points;
points = points./repmat(points(4,:),[4,1]);

end
