function [Kmin,Kmax,Dmin,Dmax] = prinCurv2(FV,queryPts)
%% Returns the directions and magnitudes of the principle curvatures of a
% 3D mesh at queryPts
% Input:
% FV - structure with 2 matrices 
%      FV.faces - #faces x 3 matrix
%      FV.vertices - #vertices x 3 matrix
% queryPts - #queryPts x 3 matrix
% Output:
% Kmin - smallest principle curvature (#queryPts x 1 matrix)
% Kmax - largest principle curvature (#queryPts x 1 matrix)
% Dmin - direction of smallest principle curvature (#queryPts x 3 matrix)
% Dmax - direction of largest principle curvature (#queryPts x 3 matrix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Compute the principle curvatures and directions at the vertices
[Cmean,Cgaussian,Dir1,Dir2,Lambda1,Lambda2]=patchcurvature(FV,true);

% %% Construct a k-d Tree from vertices
% kdTreeVertices = KDTreeSearcher(FV.vertices,'Distance','euclidean','BucketSize',1);
% 
% %% Find NN of the queryPts in the vertices
% [idxVertices, distances]= knnsearch(kdTreeVertices,queryPts,'K',3);
% 
% %% Interpolate
% N = size(queryPts,1);
% Kmin = zeros(N,1);
% Kmax = zeros(N,1);
% Dmin = zeros(N,3);
% Dmax = zeros(N,3);
% sumDistance = sum(distances,2);
Kmax = Lambda2;
Kmin = Lambda1;
Dmax = Dir2;
Dmin = Dir1;
% for i=1:N
%     Kmax(i,1) = Lambda2(idxVertices(i,:)',1);
%     Kmin(i,1) = factor*Lambda1(idxVertices(i,:)',1); 
%     Dmax(i,:) = factor*Dir2(idxVertices(i,:)',:);
%     Dmin(i,:) = factor*Dir1(idxVertices(i,:)',:);
% end

