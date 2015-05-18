function [distSorted, distIdx] = distancePrune(corr1, corr2)
% Input -
% corr1 - 3 x #numCorr matrix of points
% corr2 - 3 x #numCorr matrix of points
% Output -
% distSorted - #numCorr x 1 array of distances between correspondeces
% sortedin ascending order
% distIdx - #numCorr x 1 array of indices for the correspondences as they
% appear in sorted order
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numCorr = size(corr1,2);
dist = zeros(numCorr,1);
% for i=1:numCorr
%     dist(i,1) = norm(corr1(:,i)-corr2(:,i),2);
% end
del = (corr1' - corr2');
dist = sum((del.^2),2);
dist = dist.^(0.5);
[distSorted, distIdx] = sort(dist,'ascend');
    