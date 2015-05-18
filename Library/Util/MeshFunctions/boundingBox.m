function [ Mesh,bb ] = boundingBox( Mesh )
% return the axis aligned bounding box

x = [min(Mesh.v(1,:)),max(Mesh.v(1,:))];
y = [min(Mesh.v(2,:)),max(Mesh.v(2,:))];
z = [min(Mesh.v(3,:)),max(Mesh.v(3,:))];

bb = combvec(x,y,z);
bb = bb(:,[2,6,8,4,1,5,7,3]);

Mesh.bb = bb;

end