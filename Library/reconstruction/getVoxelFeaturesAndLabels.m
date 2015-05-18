function [X,Y] = getVoxelFeaturesAndLabels(deformation_data, matches_data)

N = size(deformation_data,1);

Neighbor = voxel6connected(200,200,200);

XCell = cell(N,1);
YCell = cell(N,1);

depthDist = matches_data.depthDist;

for i=1:N
    try
        %        disp(['reconstructing validation image:  '  num2str(i)])
        if(~isempty(deformation_data{i,1}))
            [XCell{i,1},YCell{i,1}] = getAndAppendFeatures(deformation_data{i,1},min(depthDist{i}),Neighbor);
        %        disp(['completed '  num2str(i)])
        end
    catch error
        disp(['COULD NOT RECONSTRUCT  IMAGE  ' num2str(i)]);
        disp(getReport(error));
    end
end

X = cell2mat(XCell);
Y = cell2mat(YCell);

end


function [X Y] = getAndAppendFeatures(deformation_data_single, ...
                                      depth_dist,Neighbor)

[X Y] = getVoxelFeatAndLabelsInner(deformation_data_single,Neighbor);
X = [X depth_dist*ones(size(X,1),1)];

end