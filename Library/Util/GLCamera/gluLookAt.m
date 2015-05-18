function [ M ] = gluLookAt( eyeLoc, pointOfInterest, up )
%GLULOOKAT Summary of this function goes here
%   Detailed explanation goes here

% F = pointOfInterest - eyeLoc;
% f = F/norm(F);
% UP_ = up/norm(up);
% 
% s = cross(f,UP_);
% u = cross(s/norm(s),f);
% 
% M = [eye(3),-eyeLoc';0,0,0,1]*[s',u',-f',zeros(3,1);0,0,0,1];


% Let E be the 3d column vector (eyeX, eyeY, eyeZ).
% Let C be the 3d column vector (centerX, centerY, centerZ).
% Let U be the 3d column vector (upX, upY, upZ).
% Compute L = C - E.
% Normalize L.
% Compute S = L x U.
% Normalize S.
% Compute U' = S x L.

%eyeLoc = [eyeLoc(1), eyeLoc(3), eyeLoc(2)];

L = pointOfInterest - eyeLoc;% eyeLoc - pointOfInterest;
L = L/norm(L);
S = cross(L, up);
S = S/norm(S);
up_prime = cross(S, L);

% M is the matrix whose columns are, in order:
% 
% (S, 0), (U', 0), (-L, 0), (-E, 1)  (all column vectors)

M = [S', up_prime', -L', zeros(size(eyeLoc'));0,0,-norm(eyeLoc),1]';

end

