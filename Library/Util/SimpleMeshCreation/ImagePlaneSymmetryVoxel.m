function [ mesh ] = ImagePlaneSymmetryVoxel( depthmap )

voxel = false(size(depthmap,1), size(depthmap,2), 256*2);

depthmap_mask = depthmap~=255;

[X,Y] = find(depthmap_mask);
Z = max(1, uint32(depthmap(depthmap_mask)));
back_Z = max(Z)+(max(Z)-Z);
flip_point = double(max(Z))/(256.0);

for i = 1:length(X)
    voxel(X(i), Y(i), Z(i):back_Z(i)) = true;
end

voxel = voxel(1:10:end,1:10:end, 1:10:end)==1;
[ X,Y,Z,c] = voxelToIso( voxel );

[F,V] = MarchingCubes(X,Y,Z,c,0);

mesh.f = F';
mesh.v = V'*10;

% this gets it into the right coords for running invert camera
mesh.v(3,:) = mesh.v(3,:)/(256);

xmin = min(mesh.v(1,:));
xmax = max(mesh.v(1,:));
xmin = xmin-.1*(xmax-xmin);
xmax = xmax+.1*(xmax-xmin);

ymin = min(mesh.v(2,:));
ymax = max(mesh.v(2,:));
ymin = ymin-.1*(ymax-ymin);
ymax = ymax+.1*(ymax-ymin);

mesh.sym_plane.v = [xmax,ymax,flip_point,1;xmax,ymin,flip_point,1;xmin,ymin,flip_point,1; xmin,ymax,flip_point,1]';
mesh.sym_plane.f = [1,2,4;2,3,4]';

% [M,P,V] = getCamera(struct('camera',camera));
% M(1:3,1:3) = eye(3);
% %M(1:3,4) = 0;
% 
% Carve(depthmap, @(x)ApplyCamera(x,M,P,V));

end

