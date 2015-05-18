function [mesh] = dt_all(pcl)
warning('depreciated, no replacement');
%pcl = pcl(:,1:10:end);
delaunayTriangulation(pcl');
[tri, Xb] = freeBoundary(ans);

% map Xb onto XYZ
[~,IA,IB]=intersect(pcl', Xb, 'rows');

% permute the surface triangulation points using IB map
Xbn     = Xb(IB,:);

% map the point numbers used in triangle definitions
% NOTE: for that you need inverse map
iIB(IB) = 1:length(IB);
trin    = iIB(tri);

mesh.v = Xbn';
mesh.f = trin';

%trisurf(trin,Xbn(:,1),Xbn(:,2),Xbn(:,3),Cn,'EdgeAlpha',0,'FaceColor','interp');
end
