setup_shape_reconstruction

load([OutputDir 'voxel_classifier_' FEATURE_TYPE '/voxel_classifier_model.mat']);
load([OutputDir 'features_labels_Train2Subset.mat']);
if(strcmp(FEATURE_TYPE,'BASIC'))
    FEATURES = features_Train2Subset(:,1:4);
else
    FEATURES = features_Train2Subset;
end

voxel_classifier = createVoxelClassifier(voxel_classifier_model, OutputDir, ...
                                             FEATURE_TYPE, CLASSIFIER_TYPE);	
LLRatio = voxel_classifier(FEATURES);

mask = LLRatio(:,1)>0;
prediction = zeros(size(FEATURES,1),1);
prediction(mask) = 1;
prediction(~mask) = -1;

difference = (labels_Train2Subset + prediction)/2;
accuracy = difference'*difference/size(difference,1)

