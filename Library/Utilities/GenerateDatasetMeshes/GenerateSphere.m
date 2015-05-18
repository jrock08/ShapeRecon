function [ mesh ] = GenerateSphere(stretch_x, stretch_y, stretch_z)

Xs = randn(3,500);
v = Xs./repmat(sqrt(sum(Xs.^2)),[3,1]);

v(1,:) = v(1,:)*stretch_x;
v(2,:)= v(2,:)*stretch_y;
v(3,:) = v(3,:)*stretch_z;

v = rejection_sample(v, .05);
mesh = pcl_to_mesh(v);
end

