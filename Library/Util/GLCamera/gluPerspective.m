function [ P ] = gluPerspective( fovy, aspect, zNear, zFar )
%GLUPERSPECTIVE Summary of this function goes here
%   Detailed explanation goes here
f = cot(fovy/2);
%f = cotd((fovy*180/pi)/2);

P = [f / aspect, 0, 0, 0;
     0, f, 0, 0;
     0, 0, (zFar + zNear) / (zNear - zFar), (2 * zFar * zNear) / (zNear - zFar);
     0, 0, -1, 0];
end