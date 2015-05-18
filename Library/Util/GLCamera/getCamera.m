function [M,P,V] = getCamera(c)
if(isfield(c, 'camera'))
  c = c.camera;
end

M = gluLookAt(c.position, c.point_of_interest, c.up);
% todo: This is pretty fragile, I should output the near and far clipping
% plane and the aspect ratio in the rendering code.
d = norm(c.position-c.point_of_interest);
P = gluPerspective(c.angle, 1, d-2, d+2);
V = [0, 0, 1000, 1000];
end
