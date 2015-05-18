function idx = normalPruning(normals,ptIdx1,ptIdx2,pts)
% Returns the indices of the point pairs remaining after normal pruning.
% The pruning is done on the basis of the fact that points related by
% reflexive symmetry must have normals that intersect on the reflection
% plane. Since in a practical setting the normals may not actually
% intersect we find the coordinates of the points on the normal lines that
% are closest to each other and constrain it to be close to each other and
% to the reflection plane.
% Input:
% normals - #points x 3 matrix of normal unit vectors
% pts - #points x 3 vector of points
% ptIdx1 - #point_pairs x 1 vector of indices corresponding to first point
% in a point pair
% ptIdx2 - #point_pairs x 1 vector of indices corresponding to second point
% in a point pair
% Output:
% idx - #pruned_point_pairs x 1 vector of indices. I=idx(i,1) picks a pair
% (pts(ptIdx1(I,1)),pts(ptIdx2(I,1))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Iterate over each point pair
idxTmp = zeros(size(ptIdx1,1),1);
for pairIdx = 1:size(ptIdx1,1)
    a = pts(ptIdx1(pairIdx,1),:)';
    b = pts(ptIdx2(pairIdx,1),:)';
    l1 = normals(ptIdx1(pairIdx,1),:)';
    l2 = normals(ptIdx2(pairIdx,1),:)';
    [poi, dist] = approxLineIntersect(a,b,l1,l2);
    m = (a + b)/2;
    q = poi - m;
    q = q./norm(q);
    n = (a - b);
    n = n./norm(n);
    if(abs(n' * q) < 0.05 && dist < 0.01)
        idxTmp(pairIdx) = 1;
    end
end
mask = (idxTmp == 1);
numList = [1:size(ptIdx1)]';
idx = numList(mask);

