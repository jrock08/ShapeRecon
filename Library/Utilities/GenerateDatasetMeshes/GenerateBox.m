function [ mesh ] = GenerateBox( height, width, length )
npoints = 1000;

square = rand(2,npoints)-.5;
%square = rejection_sample(square, .05);

top = [square; ones(1,npoints)*.5];
bottom = [square; ones(1,npoints)*-.5];

square2 = rand(2,1000)-.5;
right = [ones(1,npoints)*.5; square2];
left = [ones(1,npoints)*-.5; square2];

square3= rand(2,1000)-.5;
front = [square3(1,:); ones(1,npoints)*.5; square3(2,:)];
back = [square3(1,:); ones(1,npoints)*-.5; square3(2,:)];

v = [top,bottom,left,right,front,back];

c = -.5:.1:.5;
o = .5*ones(size(c));
z = zeros(size(c));

corners_and_edges = ...
[c, c, c, c,   o, o, -o, -o, o, o, -o, -o; ...
 o, o, -o, -o, c, c, c, c,   o, -o, -o, o; ...
 o, -o, -o, o, o, -o, -o, o, c, c, c, c];

v(1,:) = v(1,:)*height;
v(2,:) = v(2,:)*width;
v(3,:) = v(3,:)*length;

corners_and_edges(1,:) = corners_and_edges(1,:)*height;
corners_and_edges(2,:) = corners_and_edges(2,:)*width;
corners_and_edges(3,:) = corners_and_edges(3,:)*length;

v = rejection_sample(v, .05);

v = [corners_and_edges, v];

mesh = pcl_to_mesh(v);
% displayMesh(mesh);
% hold on;
% plot3(corners_and_edges(1,:), corners_and_edges(2,:), corners_and_edges(3,:), 'xr');
end

