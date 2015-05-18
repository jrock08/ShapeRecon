restoredefaultpath;

try
poissonRecon
catch
end

addpath(genpath('~/Documents/MATLAB/thirdParty'));
addpath(genpath('/home/daeyun/git/poisson-surface-reconstruction'));

[x, y, z] = sphere(15);
pts = [x(:), y(:), z(:)];
normals = normalize(-pts);

% figure;
% drawPoint3d(pts);
% drawEdge3d([pts, pts+normalize(normals)*0.15]);
% axis equal; grid on;

fullDepth = 6;
scale = 1.1;
samplesPerNode = 1;
cgDepth = 3;

% [faces, vertices] = poissonRecon(pts, normals, 8, fullDepth, ...
%     scale, samplesPerNode, cgDepth, 1);
[faces, vertices] = poissonRecon(pts, normals, 3);


figure;
trimesh(faces, vertices(:,1), vertices(:,2), vertices(:,3));
axis equal; grid on;
