function [mesh_viewport, mesh_projected, mesh_rotated ] = ApplyCamera( mesh, rotation, perspective, viewport )
% Rotation: Rotation is 4x4 rotation matrix, use the transpose of the
% gluLookAt matrix.
% Perspective: Perspective, use gluPerspective
% viewport: changes from default view (probably -1,1)

if(isstruct(mesh))
    points = mesh.v;
else
    points = mesh;
end

if(isempty(points))
  mesh_viewport = [];
  mesh_projected = [];
  mesh_rotated = [];
  return;
end

[p_viewport, p_projected, p_rotated] = ApplyCamera_(points, rotation, perspective, viewport);
if(isstruct(mesh))
    mesh_viewport = mesh;
    mesh_viewport.v = p_viewport;
    mesh_projected = mesh;
    mesh_projected.v = p_projected;
    mesh_rotated = mesh;
    mesh_rotated.v = p_rotated;
else
    mesh_viewport = p_viewport;
    mesh_projected = p_projected;
    mesh_rotated = p_rotated;
end

end

function [p_viewport, p_projected, p_rotated] = ApplyCamera_(points, rotation, perspective, viewport)
p_rotated = rotation * [points; ones(1,size(points,2))];

p_projected = perspective * p_rotated;

%mesh_rotated.v(1:3,:) = mesh_rotated.v(1:3,:) ./ repmat(mesh_rotated.v(4,:),[3,1]);
p_projected = p_projected ./ repmat(p_projected(4,:),[4,1]);


p_viewport = p_projected;

p_viewport(3,:) = (p_viewport(3,:)+1)/2;
p_viewport(1,:) = (p_viewport(1,:)+1)*(viewport(3)/2)+viewport(1);
p_viewport(2,:) = (1-p_viewport(2,:))*(viewport(4)/2)+viewport(2);
end
