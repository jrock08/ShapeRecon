clear all
close all
clc
%% Read the vertices from the .off mesh file format files
filepath=['C:\Users\Tanmay Gupta\Dropbox\UIUC\RA\Shape and Material from Single Image\Dataset\Mesh_Pairs\Mug_Mug'];
[vertices, faces] = read_mesh([filepath '\src_mug.off']);
% [vertices, faces] = read_mesh([filepath 'tgt_HandGun.off']);

minCoord = min(min(vertices));
maxCoord = max(max(vertices));
range = maxCoord - minCoord;

%% find the scaling factor
VOXEL_SCALE = 200;
s = VOXEL_SCALE/range;

%% scale and translate the vertices
FV.vertices = (vertices' - minCoord)*s;
FV.faces = faces';

%% voxelize the mesh
Volume=polygon2voxel(FV,[1 1 1]*VOXEL_SCALE,'none');
[Y,X,Z]=ind2sub(size(Volume),find(Volume(:)));
figure, plot3(X,Y,Z,'x');
axis equal;
figure, plot3(vertices(1,:),vertices(2,:),vertices(3,:),'rx');
axis equal;

%% Compute Center of Mass
centerOfMass(1,1) = mean(X)/s + minCoord;
centerOfMass(2,1) = mean(Y)/s + minCoord;
centerOfMass(3,1) = mean(Z)/s + minCoord;

%% visualization 1
figure, plot3(X/s + minCoord -centerOfMass(1,1),Y/s + minCoord-centerOfMass(2,1),Z/s + minCoord-centerOfMass(3,1),'.');
axis equal;
figure, plot3(vertices(1,:) - centerOfMass(1,1),vertices(2,:)-centerOfMass(2,1),vertices(3,:)-centerOfMass(3,1),'.');
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');




