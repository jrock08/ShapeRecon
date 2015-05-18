function [ax] = displayMesh( Mesh, params )
if(nargin < 2)
    params = struct('edgecolor','black','markercolor','green');
end
%trimesh(Mesh.f',Mesh.v(1,:),Mesh.v(2,:),Mesh.v(3,:),'edgecolor', params.edgecolor,'facecolor',params.edgecolor,'facealpha',.3);

if size(Mesh.v, 1) > size(Mesh.v, 2), Mesh.v = Mesh.v'; end
if size(Mesh.f, 1) > size(Mesh.f, 2), Mesh.f = Mesh.f'; end

[ax] = trisurf(Mesh.f',Mesh.v(1,:),Mesh.v(2,:),Mesh.v(3,:),'edgecolor',params.edgecolor,'edgealpha',.2,'facealpha',1);
hold on;
if(isfield(Mesh,'I'))
    plot3(Mesh.I(:,1),Mesh.I(:,2),Mesh.I(:,3),'x','MarkerEdgeColor',params.markercolor,'MarkerSize',10,'linewidth',3);
end

if(isfield(Mesh,'bb'))
    plot3(Mesh.bb(1,:),Mesh.bb(2,:),Mesh.bb(3,:),'-xr')
    labels = cellstr( num2str([1:size(Mesh.bb,2)]') );
    text(Mesh.bb(1,:),Mesh.bb(2,:),Mesh.bb(3,:), labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')


end
