% Usage [points, normals] = computeVoxelNormals(surfaceVoxel, volumeVoxel, ...
%   'windowSize', 1, 'showFigure', true, 'multiplier', 1)
function [points, normals] = ...
        computeVoxelNormals(surfaceVoxel, volumeVoxel, varargin)

p=inputParser;
addOptional(p, 'windowSize', 1, @isnumeric);
addOptional(p, 'showFigure', false);
addOptional(p, 'multiplier', 1, @isnumeric);
addOptional(p, 'isWeighted', true);
parse(p, varargin{:});
args = p.Results;
%%

maxval = max(surfaceVoxel(:));
minval = min(surfaceVoxel(:));

surfPointInds = find(surfaceVoxel);
dims = size(surfaceVoxel);

t = args.windowSize;
[a,b,c] = meshgrid(-t:t,-t:t,-t:t);
dxyz = [a(:) b(:) c(:)];

normals = zeros(numel(surfPointInds), 3);
points = zeros(numel(surfPointInds), 3);

[X, Y, Z] = ind2sub(dims, surfPointInds);

for i = 1:numel(surfPointInds)
    pointInd = surfPointInds(i);

    if args.isWeighted
        surfaceVoxelVal = double(surfaceVoxel(pointInd)-minval+1) / ...
            double(maxval-minval+1);
    else
        surfaceVoxelVal = 1;
    end

    x=X(i); y=Y(i); z=Z(i);

    nhood = dxyz + repmat([x, y, z], [size(dxyz, 1) 1]);
    validNhoodInds = ~any(nhood<1 | nhood>repmat(dims, [size(dxyz, 1) 1]), 2);
    nhood = nhood(validNhoodInds, :);
    
    nhoodInds = sub2ind(dims, nhood(:, 1), nhood(:, 2), nhood(:, 3));
    
    nhoodVoxel = volumeVoxel(nhoodInds);
    occupuedNeighbors = nhood(find(nhoodVoxel), :);
    
    pointNormal = mean(occupuedNeighbors)-[x,y,z];
    
    normals(i,:) = surfaceVoxelVal * pointNormal;
    points(i,:) = [x y z];

    if args.showFigure
        drawEdge3d([x,y,z,mean(occupuedNeighbors)]);
    end
end

normals = normals * args.multiplier;

end
