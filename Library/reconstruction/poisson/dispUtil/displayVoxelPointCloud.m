function displayVoxelPointCloud(voxel, varargin)
args=inputParser;
addOptional(args, 'color', [0 0 1]);
addOptional(args, 'marker', '.');
parse(args, varargin{:});
args = args.Results;
%%

uniqueVals = unique(voxel);
maxVal = max(voxel(:));
minVal = min(voxel(find(voxel(:))));

oppCol = ([1 1 1]-args.color)*0.6 + [1 1 1]*0.4;

for val = uniqueVals'
    if val == 0
        continue;
    end
    oneInds = find(voxel(:)==val);
    [x, y, z] = ind2sub(size(voxel), oneInds);
    if minVal == maxVal
        drawPoint3d([x y z], 'marker', args.marker, 'color', args.color);
    else
        fade = double(val-minVal+1)/double(maxVal-minVal+1);
        drawPoint3d([x y z], 'marker', args.marker, 'color', ...
            args.color*fade+oppCol*(1-fade));
    end
end
