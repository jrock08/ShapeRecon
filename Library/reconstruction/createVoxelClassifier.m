function [ fhandle ] = createVoxelClassifier(voxel_classifier_model, OutputDir, ...
                                             FEATURE_TYPE, ...
                                             CLASSIFIER_TYPE, BIAS)

fhandle = @voxelClassifier;

function LLRatio = voxelClassifier(features)
if(strcmp(FEATURE_TYPE,'BASIC'))
    FEATURES = features(:,1:4);
    
elseif(strcmp(FEATURE_TYPE,'SIMILARITY'));
    FEATURES = features;
   
end
    
if(strcmp(CLASSIFIER_TYPE,'BDT'))
    confidences = test_boosted_dt_mc(voxel_classifier_model.BDT, ...
                                     FEATURES);
    LLRatio = confidences(:,1) + BIAS;

elseif(strcmp(CLASSIFIER_TYPE,'LR'))
    FEATURES = [FEATURES ones(size(FEATURES,1),1)];
    w = voxel_classifier_model.LR;
    w(end,1) = w(end,1)+BIAS;
    LLRatio = FEATURES*w;
end
    
end         

end

        
    
    
