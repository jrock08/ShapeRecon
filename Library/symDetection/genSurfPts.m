function [uniformSurfPts, chosenFaceIdx] = genSurfPts(vertices,faces,N)
% Samples the points uniformly over the entire surface of the 3D triangular
% mesh
% Inputs:
% vertices - 3 x #vertices matrix of mesh vertices
% faces - 3 x #faces matrix where the ith column contains the indices of
%         the vertices in the ith face
% N - the number of pts to sample
% Output:
% uniformSurfPts - 3 x N matrix of points sampled uniformly over the
%                   mesh surface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% compute the probability distribution over mesh faces with the probability
% of choosing the ith faces is proportional to the area of the face
probDist = zeros(1,size(faces,2));
for faceIdx = 1:size(faces,2)   
    probDist(1,faceIdx) = triangleArea3d(vertices(:,faces(:,faceIdx))'); 
end
probDist = probDist./sum(probDist);

%% Choose faces from the above distribution N times
chosenFaceIdx = gendist(probDist, 1, N);
% figure, plot([1:1:size(faces,2)], probDist,'rx');
% figure, hist(chosenFaceIdx,[1:1:size(faces,2)]);

%% Sample 1 point uniformly randomly from each chosen face 
uniformSurfPts = zeros(3,N);
for i=1:N
    alpha2 = rand;
    alpha3 = rand*(1 - alpha2);
    alpha1 = 1 - alpha2 - alpha3;
    uniformSurfPts(:,i) = vertices(:,faces(:,chosenFaceIdx(1,i)))*[alpha1; alpha2; alpha3];
end
