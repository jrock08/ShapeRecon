function [corrPruned1, corrPruned2] = spectralCorr(corr1,corr2,dist,idx1,idx2)
% Input - 
% corr1 - 3 x #numCorrs matrix of 1st correspondence points
% corr2 - 3 x #numCorrs matrix of 2nd correspondence points
% dist - an array of distances between features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numCorr = size(corr1,2);
% hop = 1;
% sigma = (std(pdist(corr1(:,1:hop:numCorr)'))+std(pdist(corr2(:,1:hop:numCorr)')))/2;
sigma = 0.1;

%% Construct the affinity matrix
M = diag(1*dist./(max(dist)));
D1 = pdist2(corr1',corr1');
D2 = pdist2(corr2',corr2');
delD = D1 - D2;
delD = delD + 10*sigma*eye(size(M,1));
mask = abs(delD) < 3*sigma;
M(mask) = (4.5 - ((delD(mask)).^2)/(2*sigma^2))*1/4.5;

%% Find principal eigenvector
[V,D] = eig(M);
eigValues = diag(D);
[sortedEigValues eigValIdx] = sort(eigValues,'descend');

%% Find matches
L = V(:,eigValIdx(1));
lim = size(find(L>-1000),1);
indices = [];
while(lim>0)
    [maxVal maxIdx] = max(L);
    indices = [indices; maxIdx];
    extraIdx1 = find(idx1==idx1(maxIdx));
    extraIdx2 = find(idx2==idx2(maxIdx));
    L(extraIdx1,1)=-1000;
    L(extraIdx2,1)=-1000;
    lim = size(find(L>-1000),1);
end
corrPruned1 = corr1(:,indices);
corrPruned2 = corr2(:,indices);



