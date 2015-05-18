function bestBias = lineSearchForBias(OutputDir, FEATURE_TYPE, ...
                                  CLASSIFIER_TYPE)

load([OutputDir 'deformation_ValidationSubset.mat']);
load([OutputDir 'matches_ValidationSubset.mat']);
load([OutputDir 'voxel_classifier_' FEATURE_TYPE '/' ...
                    'voxel_classifier_model.mat']);

BIAS = [0:0.2:2]';
N = size(BIAS,1)

Table_of_Means = cell(N,1);
Table_of_Medians = cell(N,1);

for b=1:N
    voxel_classifier = createVoxelClassifier(voxel_classifier_model, ...
                                             OutputDir, ...
                                             FEATURE_TYPE,CLASSIFIER_TYPE,BIAS(b,1));
    reconstructed_meshes_ValidationSubset = cell(3,1);
    for i=1:3
        [reconstructed_meshes_ValidationSubset{i,1}] = ...
            reconstruct_shape(deformation_ValidationSubset{i,1}, ...
                              voxel_classifier, matches_ValidationSubset{i,1});
    end

    metrics_reconstruction_ValidationSubset = cell(3,1);
    for i = 1:3
         metrics_reconstruction_ValidationSubset{i,1} = ...
             computeMetricsDeformed(reconstructed_meshes_ValidationSubset{i,1});
    end

    [table_mean, table_median] = ...
        genStats(metrics_reconstruction_ValidationSubset);
    
    Table_of_Means{b,1} = table2cell(table_mean);
    Table_of_Medians{b,1} = table2cell(table_median);
end
keyboard;
save([OutputDir 'Table_of_Means_' FEATURE_TYPE '_' ...
      CLASSIFIER_TYPE '.mat'],'Table_of_Means');
save([OutputDir 'Table_of_Medians_' FEATURE_TYPE '_' ...
      CLASSIFIER_TYPE '.mat'],'Table_of_Medians');

surfDistRecSym = zeros(N,1);
voxelIOU = zeros(N,1);

for b=1:N
    surfDistRecSym(b,1) = Table_of_Means{b,1}{1,4} + ...
        Table_of_Means{b,1}{2,4} + Table_of_Means{b,1}{3,4};
    voxelIOURecSym(b,1) = Table_of_Means{b,1}{1,end} + ...
        Table_of_Means{b,1}{2,end} + Table_of_Means{b,1}{3,end};
end

surfDistRecSym = surfDistRecSym/3;
voxelIOURecSym = voxelIOURecSym/3;

plot(BIAS,surfDistRecSym,'r-',...
     BIAS,voxelIOURecSym,'b-');
savefig(gcf,[OutputDir 'BIAS_' FEATURE_TYPE '_' CLASSIFIER_TYPE]);

[~,idx] = max(surfDistRecSym);
bestBias = BIAS(idx,1);
    