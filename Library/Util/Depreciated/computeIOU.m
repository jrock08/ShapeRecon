function [iou] = computeIOU(query, match)
    warning('depreciated, use voxelIOUScore instead');
    iou = sum(query(:) & match(:)) / sum(query(:) | match(:));
end
