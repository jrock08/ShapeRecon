function [poi, dist] = approxLineIntersect(a,b,l1,l2)
% Given 2 lines which may or may not be skewed with respect to each other
% the function computes the point that would approximate their point of
% intersection, i.e that average of the position of points on the two lines
% which are closest to each other
% Input :
% 2 lines - r1 = a + l1 * t1 and r2 = b + l2 * t2
% a and b are a point of the line each (3 x 1 vectors)
% l1 and l2 are unit vectors along the directions of the lines each (3 x 1 vectors)
% Output :
% poi - point of intersection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Compute t1 and t2
c = a - b;
t1 = l1'*(l2*l2'-eye(3))*c./(1.001-(l1'*l2)^2);
t2 = l2'*(eye(3)-l1*l1')*c./(1.001-(l1'*l2)^2);

%% Compute the points
r1 = a + l1 * t1;
r2 = b + l2 * t2;
dist = norm(r2-r1);

%% return the average of the two points
poi = (r1 + r2)./2;