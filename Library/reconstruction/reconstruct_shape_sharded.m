function [meshes] = reconstruct_shape_sharded(deformation_data,voxel_classifier,...
                                      matches_data, SHARD_NUM, NUM_SHARDS)

N = size(deformation_data,1);

Neighbor = voxel6connected(200,200,200);
meshes = cell(N,1);

depthDist = matches_data.depthDist;

for i=1:N
    if(mod(i-1,NUM_SHARDS)+1~=SHARD_NUM)
        meshes{i,1} = [];
        continue;
    end

    try
        disp(['reconstructing test image:  '  num2str(i)])
        if(~isempty(deformation_data{i,1}))
            [meshes{i,1}] = getMeshData(deformation_data{i,1}, ...
                                        Neighbor,voxel_classifier, min(depthDist{i}));
            disp(['completed '  num2str(i)]);;
        else
            meshes{i,1} = [];
        end
    catch err
        disp(getReport(err));
        disp(['COULD NOT RECONSTRUCT TEST IMAGE:  ' num2str(i)]);
    end
end