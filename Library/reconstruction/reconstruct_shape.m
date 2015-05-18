function [meshes] = reconstruct_shape(deformation_data,voxel_classifier,...
                                      matches_data, subset)
N = size(deformation_data,1);
if(nargin < 4)
    subset = 1:N;
end

Neighbor = voxel6connected(200,200,200);
meshes = cell(N,1);

depthDist = matches_data.depthDist;

for i=subset
    try
        disp(['reconstructing test image:  '  num2str(i)])
        if(~isempty(deformation_data{i,1}))
            [meshes{i,1}] = getMeshData(deformation_data{i,1}, ...
                                        Neighbor,voxel_classifier, min(depthDist{i}));
            disp(['completed '  num2str(i)]);
        else
            meshes{i,1} = [];
        end
    catch err
        disp(getReport(err));
        disp(['COULD NOT RECONSTRUCT TEST IMAGE:  ' num2str(i)]);
    end
end

