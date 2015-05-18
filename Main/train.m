setup_shape_reconstruction;

% Check if the iminfos for Train1, Train2Subset and Train are
% created already and if not then create them with the following
% file paths:
% <OutputDir>/iminfo_Train1.mat
% <OutputDir>/iminfo_Train2Subset.mat
% <OutputDir>/iminfo_Train.mat

check_iminfo(OutputDir,path_to_Train1,'Train1',TRAIN_FORCE_CREATE_IMINFO, 'combined');
if(TRAIN_USE_SUBSET)
    check_iminfo(OutputDir, path_to_Train2Subset, 'Train2Subset', ...
                 TRAIN_FORCE_CREATE_IMINFO, 'combined');
else
    check_iminfo(OutputDir,path_to_Train2, 'Train2', ...
                 TRAIN_FORCE_CREATE_IMINFO, 'combined');
end
check_iminfo(OutputDir,path_to_Train,'Train', TRAIN_FORCE_CREATE_IMINFO, 'combined');

%% Train RF using Train1
if(TRAIN_RF_TRAIN1)
    if(exist('iminfo_Train1','var')~=1)
        load([OutputDir 'iminfo_Train1.mat']);
    end
    [RF_Model_Train1] = train_RF(iminfo_Train1);
    save([OutputDir 'RF_Model_Train1'], 'RF_Model_Train1', '-v7.3');
    disp('Trained RF_Model_Train1');
end

%% Concatenate Train1 and Train2Subset
if(exist([OutputDir 'iminfo_Train1_Train2Subset.mat'])~=2)
    load([OutputDir 'iminfo_Train1.mat']);
    load([OutputDir 'iminfo_Train2Subset.mat']);
    iminfo_Train1_Train2Subset = struct_concat(iminfo_Train1, ...
                                               iminfo_Train2Subset);
    save([OutputDir 'iminfo_Train1_Train2Subset.mat'], 'iminfo_Train1_Train2Subset');
end

%% Train RF using Train
if(TRAIN_RF_TRAIN)
    if(exist('iminfo_Train','var')~=1)
        load([OutputDir 'iminfo_Train.mat']);
    end
    [RF_Model_Train] = train_RF(iminfo_Train);
    save([OutputDir 'RF_Model_Train'], 'RF_Model_Train', '-v7.3');
    disp('Trained RF_Model_Train');
end


%% Run matching on Train2Subset
if(TRAIN_RUN_MATCH_TRAIN2SUBSET)
    if(exist('RF_Model_Train1','var')~=1)
        load([OutputDir 'RF_Model_Train1.mat']);
    end
    if(exist('iminfo_Train2Subset','var')~=1)
        load([OutputDir 'iminfo_Train2Subset.mat']);
    end
    if(exist('iminfo_Train1_Train2Subset','var')~=1)
        load([OutputDir 'iminfo_Train1_Train2Subset.mat']);
    end
    [ matches_Train2Subset ] = test_RF(RF_Model_Train1,iminfo_Train2Subset, 1000, TRAIN_PIPELINE_MODE);

    % Compute Metrics for these matches
    matches_Train2Subset = computeMetricsMultiple(matches_Train2Subset, ...
                                                  iminfo_Train1_Train2Subset);

    save([OutputDir 'matches_Train2Subset.mat'], ...
         'matches_Train2Subset','-v7.3');
    disp('Ran matching on Train2Subset');
end


%% Run deformation on Train2Subset
if(TRAIN_RUN_DEFORMATION_PIPELINE)
    if(exist('matches_Train2Subset','var')~=1)
        load([OutputDir 'matches_Train2Subset.mat']);
    end
    if(exist('iminfo_Train1_Train2Subset','var')~=1)
        load([OutputDir 'iminfo_Train1_Train2Subset.mat']);
    end

    deformation_Train2Subset = runDeformationPipeline(matches_Train2Subset, iminfo_Train1_Train2Subset,...
                                                      OutputDir,TRAIN_PIPELINE_MODE);
    save([OutputDir 'deformation_Train2Subset.mat'], ...
         'deformation_Train2Subset', '-v7.3');
    disp('Ran deformation on Train2Subset');
end

%% Extract features from Train2Subset
if(TRAIN_EXTRACT_FEATURES)
    if(exist('deformation_Train2Subset','var')~=1)
        load([OutputDir 'deformation_Train2Subset.mat']);
    end
    if(exist('matches_Train2Subset','var')~=1)
        load([OutputDir 'matches_Train2Subset.mat']);
    end
    [features_Train2Subset, labels_Train2Subset] = ...
        getVoxelFeaturesAndLabels(deformation_Train2Subset, matches_Train2Subset);
    save([OutputDir 'features_labels_Train2Subset.mat'], ...
         'features_Train2Subset','labels_Train2Subset','-v7.3');
    disp('Extracted features from Train2Subset');
end

%% Train voxel classifier
if(TRAIN_VOXEL_CLASSIFIER)
    if((exist('features_Train2Subset','var')~=1) || ...
       (exist('labels_Train2Subset','var')~=1))
        load([OutputDir 'features_labels_Train2Subset.mat']);
    end

    if(exist([OutputDir 'voxel_classifier_' FEATURE_TYPE '/voxel_classifier_model.mat'],'file')==2)
        load([OutputDir 'voxel_classifier_' FEATURE_TYPE '/voxel_classifier_model.mat']);
    end

    sample_stride = 100;
    if(strcmp(FEATURE_TYPE,'BASIC'))
        FEATURES = features_Train2Subset(1:sample_stride:end,1:4);
        mkdir([OutputDir 'voxel_classifier_BASIC']);
    else
        FEATURES = features_Train2Subset(1:sample_stride:end,:);
        mkdir([OutputDir 'voxel_classifier_SIMILARITY']);
    end
    LABELS = labels_Train2Subset(1:sample_stride:end,1);


    if(strcmp(CLASSIFIER_TYPE,'BDT'))
        voxel_classifier_model.BDT = train_boosted_dt_2c(FEATURES, ...
                                               [],LABELS, ...
                                               20, 4);
    elseif(strcmp(CLASSIFIER_TYPE,'LR'))
        valfraction = 0.3;
        Bset = [1 2 4 8 16 32];
        [w, ll, bestB] = trainLogisticRegressionL2_2(FEATURES, LABELS, valfraction, ...
                                             Bset);
        voxel_classifier_model.LR = w;
        save([OutputDir 'tmpData/LR_BASIC.mat'],'w','ll','bestB');
    end
    save([OutputDir 'voxel_classifier_' FEATURE_TYPE '/' ...
                        'voxel_classifier_model.mat'],'voxel_classifier_model');
    disp('Trained voxel classifier on Train2Subset');
end




