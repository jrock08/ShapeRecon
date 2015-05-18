function printStatsDeformed(file)
if(isstruct(file))
    metrics = file;
else
    metrics = load(file);
    if(isfield(metrics, 'metrics'))
       metrics = metrics.metrics; 
    end
end
    
    fprintf('ALIGNED MESH VS MATCH MESH\n');
    fprintf('Voxel IOU Mean: %f\n', mean(metrics.voxelIOU));
    fprintf('Voxel IOU Median: %f\n', median(metrics.voxelIOU));
    fprintf('Voxel Distance Normalized Mean: %f\n', mean(metrics.voxelDist));
    fprintf('Voxel Distance Normalized Median: %f\n', median(metrics.voxelDist));
    fprintf('Surface Distance Mean: %f\n', mean(metrics.surfaceDist));
    fprintf('Surface Distance Median: %f\n', median(metrics.surfaceDist));
    
    fprintf('\nALIGNED MESH VS DEFORMED MESH\n');
    fprintf('Voxel IOU Mean: %f\n', mean(metrics.voxelIOUDeformed));
    fprintf('Voxel IOU Median: %f\n', median(metrics.voxelIOUDeformed));
    fprintf('Voxel Distance Normalized Mean: %f\n', mean(metrics.voxelDistDeformed));
    fprintf('Voxel Distance Normalized Median: %f\n', median(metrics.voxelDistDeformed));
    fprintf('Surface Distance Mean: %f\n', mean(metrics.surfaceDistDeformed));
    fprintf('Surface Distance Median: %f\n', median(metrics.surfaceDistDeformed));
    
    fprintf('\nALIGNED MESH VS RECONSTRUCTED MESH\n');
    fprintf('Voxel IOU Mean: %f\n', mean(metrics.voxelIOUReconstructedNoSym));
    fprintf('Voxel IOU Median: %f\n', median(metrics.voxelIOUReconstructedNoSym));
    fprintf('Voxel Distance Normalized Mean: %f\n', mean(metrics.voxelDistReconstructedNoSym));
    fprintf('Voxel Distance Normalized Median: %f\n', median(metrics.voxelDistReconstructedNoSym));
    fprintf('Surface Distance Mean: %f\n', mean(metrics.surfaceDistReconstructedNoSym));
    fprintf('Surface Distance Median: %f\n', median(metrics.surfaceDistReconstructedNoSym));
    
    fprintf('\nALIGNED MESH VS RECONSTRUCTED SYMMETRY MESH\n');
    fprintf('Voxel IOU Mean: %f\n', mean(metrics.voxelIOUReconstructedSym));
    fprintf('Voxel IOU Median: %f\n', median(metrics.voxelIOUReconstructedSym));
    fprintf('Voxel Distance Normalized Mean: %f\n', mean(metrics.voxelDistReconstructedSym));
    fprintf('Voxel Distance Normalized Median: %f\n', median(metrics.voxelDistReconstructedSym));
    fprintf('Surface Distance Mean: %f\n', mean(metrics.surfaceDistReconstructedSym));
    fprintf('Surface Distance Median: %f\n', median(metrics.surfaceDistReconstructedSym));

end

function ret = median(data)
    data = sort(data);
    i = length(data) / 2;
    if(i < 1)
       ret = data(1); 
    else
        ret = (data(floor(i)) + data(ceil(i))) / 2;
    end
end