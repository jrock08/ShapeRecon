function [meshes] =  merge_sharded_reconstruction(path_to_Reconstruction_Sharded, ...
                                                  NUM_SHARDS)
meshes = cell(3,1);
for i=1:3
    load([path_to_Reconstruction_Sharded '/' ...
                        'reconstructed_meshes_TestSubset_1.mat']);
    N = size(reconstructed_meshes_TestSubset{i,1},1);
    meshes{i,1} = cell(N,1);
    for j=1:NUM_SHARDS
        load([path_to_Reconstruction_Sharded '/reconstructed_meshes_TestSubset_' num2str(j) ...
              '.mat']);
        N = size(reconstructed_meshes_TestSubset{i,1},1);
        for j = 1:N
            if(~isempty(reconstructed_meshes_TestSubset{i,1}{j,1}))
                meshes{i,1}{j,1} = reconstructed_meshes_TestSubset{i,1}{j,1};
            end
        end
    end
end
