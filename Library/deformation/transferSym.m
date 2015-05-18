function pcl_Xfered = transferSym(pcl,symPts1,symPts2)
% Input - 
% pcl - 3 x #numPts matrix of 3d points
% symPts1 - #numSymPts x 3 matrix of first symmetry point in a pair
% symPts2 - #numSymPts x 3 matrix of second symmetry point in a pair
% Output -
% pcl_symXfered - 3 x #numPts matrix of symmetry transfered point cloud
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(isempty(symPts1))
  pcl_Xfered = [];
  return;
end

%% Create kdtree out of symPts1 and symPts2
kdTree1 = KDTreeSearcher(symPts1,'Distance','euclidean','BucketSize',50);
kdTree2 = KDTreeSearcher(symPts2,'Distance','euclidean','BucketSize',50);

%keyboard;
%% Find nearest neighbours for each point in pcl from amongst symPts1\2
[idx1, d1]= knnsearch(kdTree1,pcl');
[idx2, d2]= knnsearch(kdTree2,pcl');
idx = [idx1 idx2];
d = [d1 d2];

%% Pick the nearest symmetry point
[minDist minIdx] = min(d,[],2);
pcl_Xfered = zeros(3,size(pcl,2));
for i=1:size(pcl,2)
    if(minIdx(i)==1)
        m = (symPts1(idx1(i),:)' + symPts2(idx1(i),:)')/2;
        n = symPts1(idx1(i),:)' - symPts2(idx1(i),:)';
        n = n / (norm(n) + 0.0001);
        A = eye(3) - 2*n*n';
        t = 2*n*n'*m;
        pcl_Xfered(:,i)= A*pcl(:,i)+t;
    
    elseif(minIdx(i)==2)
        m = (symPts1(idx2(i),:)' + symPts2(idx2(i),:)')/2;
        n = symPts1(idx2(i),:)' - symPts2(idx2(i),:)';
        n = n / (norm(n) + 0.0001);
        A = eye(3) - 2*n*n';
        t = 2*n*n'*m;
        pcl_Xfered(:,i)= A*pcl(:,i)+t;
    end
    
end
% pcl_Xfered = [pcl pcl_Xfered];
