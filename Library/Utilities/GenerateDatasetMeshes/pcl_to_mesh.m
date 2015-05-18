function [ mesh ] = pcl_to_mesh( v )
dt = delaunayTriangulation(v');

[f,v] = freeBoundary(dt);
mesh.v = v';
mesh.f = f';
end

