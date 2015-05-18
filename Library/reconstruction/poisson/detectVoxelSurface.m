function voxelSurface = detectVoxelSurface(voxel, varargin)
args=inputParser;
addOptional(args, 'method', 1);
parse(args, varargin{:});
args = args.Results;
%%

switch args.method
case 1
    x1 = [1 3 1; 3 6 3; 1 3 1];
    x0 = zeros(3);
    sobelX = cat(3, -x1, x0, x1);
    sobelY = permute(sobelX, [3 1 2]);
    sobelZ = permute(sobelX, [2 3 1]);

    voxelSurface = int32(zeros(size(voxel)));
    voxelSurface = voxelSurface + abs(imfilter(voxel, sobelX));
    voxelSurface = voxelSurface + abs(imfilter(voxel, sobelY));
    voxelSurface = voxelSurface + abs(imfilter(voxel, sobelZ));

case 2
    enlarged = voxel;

    shifted = circshift(enlarged, [1 0 0]); shifted(1, :, :) = 0;
    enlarged = enlarged + shifted;
    shifted = circshift(enlarged, [-1 0 0]); shifted(end, :, :) = 0;
    enlarged = enlarged + shifted;
    shifted = circshift(enlarged, [0 1 0]); shifted(:, 1, :) = 0;
    enlarged = enlarged + shifted;
    shifted = circshift(enlarged, [0 -1 0]); shifted(:, end, :) = 0;
    enlarged = enlarged + shifted;
    shifted = circshift(enlarged, [0 0 1]); shifted(:, :, 1) = 0;
    enlarged = enlarged + shifted;
    shifted = circshift(enlarged, [0 0 -1]); shifted(:, :, end) = 0;
    enlarged = enlarged + shifted;

    voxelSurface = enlarged & ~voxel;
end

