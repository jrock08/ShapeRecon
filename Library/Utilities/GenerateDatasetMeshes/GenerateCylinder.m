function [ mesh ] = GenerateCylinder( height, width, length  )
%GENERATECYLINDER Summary of this function goes here
%   Detailed explanation goes here

nval = 2*round(500*pi);


Zs = (rand(1,nval)-.5);
rot = rand(1,nval/2) * pi;
rot = [rot,rot-pi];
Xs = sin(rot);
Ys = cos(rot);

v = [Xs; Ys; Zs];

%plot3(Xs, Ys, Zs,'xr');

r = tanh(rand(1,500)*pi);
th = rand(1,500) * 2 * pi;

cap = [sin(th).*r; cos(th).*r; ones(1,500)*.5];
cap2 = [sin(th).*r; cos(th).*r; ones(1,500)*-.5];

v = [cap, cap2, v];

v(1,:) = v(1,:)*height;
v(2,:) = v(2,:)*width;
v(3,:) = v(3,:)*length;

v = rejection_sample(v, .1);



capadd = [sin(0:2*pi/20:2*pi)*height; cos(0:2*pi/20:2*pi)*width] 

o = ones(1,size(capadd,2))*.5*length;
v = [v, [capadd; o], [capadd; -o]];

mesh = pcl_to_mesh(v);

displayMesh(mesh);
hold on;
plot3(capadd(1,:), capadd(2,:), o, 'xr');
plot3(capadd(1,:), capadd(2,:), -o, 'xr');
plot3(mesh.v(1,:), mesh.v(2,:), mesh.v(3,:), 'ob');
end

