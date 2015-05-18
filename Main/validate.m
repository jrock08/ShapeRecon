setup_shape_reconstruction;

% check_iminfo(OutputDir,path_to_Validation,'Validation',VAL_FORCE_CREATE_IMINFO);
if(VAL_USE_SUBSET)
    check_iminfo(OutputDir, path_to_ValidationSubset, ...
                 'ValidationSubset', VAL_FORCE_CREATE_IMINFO, 'segmented');
else
    check_iminfo(OutputDir, path_to_Validation, ...
                 'Validation', VAL_FORCE_CREATE_IMINFO, 'segmented');
end

%% Concatenate Train and ValidationSubset
if(VAL_FORCE_CREATE_IMINFO || ~exist([OutputDir 'iminfo_Train_ValidationSubset.mat'], 'file'))
    load([OutputDir 'iminfo_Train.mat']);
    load([OutputDir 'iminfo_ValidationSubset.mat'])
    iminfo_Train_ValidationSubset = struct_concat(iminfo_Train, ...
                                                  iminfo_ValidationSubset{1,1}, ...
                                                  iminfo_ValidationSubset{2,1}, ...
                                                  iminfo_ValidationSubset{3,1});
    save([OutputDir 'iminfo_Train_ValidationSubset.mat'], 'iminfo_Train_ValidationSubset','-v7.3');
end

%% Run matching on ValidationSubset
if(VAL_RUN_MATCH_VALSUBSET)
    if(exist('RF_Model_Train','var')~=1)
        load([OutputDir 'RF_Model_Train']);
    end
    if(exist('iminfo_ValidationSubset','var')~=1)
        load([OutputDir 'iminfo_ValidationSubset.mat']);
    end
    if(exist('iminfo_Train_ValidationSubset','var')~=1)
        load([OutputDir 'iminfo_Train_ValidationSubset.mat']);
    end

    matches_ValidationSubset = cell(3,1);
    for i=1:3
        [ matches_ValidationSubset{i,1} ] = test_RF(RF_Model_Train, ...
                                                    iminfo_ValidationSubset{i,1}, 1000, VAL_PIPELINE_MODE);

        % Compute Metrics for these matches
        matches_ValidationSubset{i,1} = computeMetricsMultiple(matches_ValidationSubset{i,1}, ...
                                                  iminfo_Train_ValidationSubset);
    end
    save([OutputDir 'matches_ValidationSubset.mat'], 'matches_ValidationSubset','-v7.3');
end

%% Run deformation pipeline on ValidationSubset
if(VAL_RUN_DEFORMATION_PIPELINE)
    if(exist('matches_ValidationSubset','var')~=1)
        load([OutputDir 'matches_ValidationSubset.mat']);
    end
    if(exist('iminfo_ValidationSubset','var')~=1)
        load([OutputDir 'iminfo_ValidationSubset.mat']);
    end
    if(exist('iminfo_Train_ValidationSubset','var')~=1)
        load([OutputDir 'iminfo_Train_ValidationSubset']);
    end

    deformation_ValidationSubset = cell(3,1);
    for i=1:3
        deformation_ValidationSubset{i,1} = runDeformationPipeline(matches_ValidationSubset{i,1},...
                                                      iminfo_Train_ValidationSubset,...
                                                      OutputDir, VAL_PIPELINE_MODE); 
    end

    save([OutputDir 'deformation_ValidationSubset.mat'], ...
         'deformation_ValidationSubset', '-v7.3');
end

if(VAL_LINESEARCH_FOR_BIAS)
    BEST_BIAS = lineSearchForBias(OutputDir,FEATURE_TYPE, ...
                                  CLASSIFIER_TYPE);
    disp(['Voila! THE BEST BIAS IS (drum-roll): ' BEST_BIAS]);
end
 
%% Run reconstruction on ValidationSubset
if(VAL_RECONSTRUCTION)
    if(exist('deformation_ValidationSubset','var')~=1)
        load([OutputDir 'deformation_ValidationSubset.mat']);
    end
    if(exist('matches_ValidationSubset','var')~=1)
        load([OutputDir 'matches_ValidationSubset.mat']);
    end

    load([OutputDir 'voxel_classifier_' FEATURE_TYPE '/voxel_classifier_model.mat']);
    voxel_classifier = createVoxelClassifier(voxel_classifier_model, OutputDir, ...
                                             FEATURE_TYPE, ...
                                             CLASSIFIER_TYPE,BIAS);
    reconstructed_meshes_ValidationSubset = cell(3,1);
    for i=1:3
        [reconstructed_meshes_ValidationSubset{i,1}] = ...
            reconstruct_shape(deformation_ValidationSubset{i,1}, ...
                              voxel_classifier, matches_ValidationSubset{i,1});
    end
    save([OutputDir 'reconstructed_meshes_ValidationSubset.mat'],'reconstructed_meshes_ValidationSubset','-v7.3');
end

%% Run computer metrics on reconstruction on ValidationSubset
if(VAL_COMPUTE_METRICS)
    if(exist('reconstructed_meshes_ValidationSubset','var')~=1)
        load('reconstructed_meshes_ValidationSubset');
    end
    
    metrics_reconstruction_ValidationSubset = cell(3,1);
    for i = 1:3
         metrics_reconstruction_ValidationSubset{i,1} = ...
             computeMetricsDeformed(reconstructed_meshes_ValidationSubset{i,1});
    end
    save([OutputDir 'metrics_reconstruction_ValidationSubset.mat'], ...
         'metrics_reconstruction_ValidationSubset');
end

%% Run Image Generation
if(VAL_IMAGE_GENERATION)
    if(exist('reconstructed_meshes_ValidationSubset','var')~=1)
        load([OutputDir 'reconstructed_meshes_ValidationSubset.mat']);
    end

    if(~exist('iminfo_ValidationSubset', 'var'))
      load([OutputDir 'iminfo_ValidationSubset.mat']);
    end

    if(exist('matches_ValidationSubset','var')~=1)
        load([OutputDir 'matches_ValidationSubset.mat']);
    end

    for i=1:3
        val_image_dir = [path_to_Results_Validation '/' Experiment{i} '/Images'];
        mkdir(val_image_dir);
        generateImage(reconstructed_meshes_ValidationSubset{i,1}, ...
                      matches_ValidationSubset{i,1}, iminfo_ValidationSubset{i},...
                      val_image_dir,VAL_SKIP);
    end
end

%% Run Video Generation
if(VAL_VIDEO_GENERATION)
    if(exist('reconstructed_meshes_ValidationSubset','var')~=1)
        load([OutputDir 'reconstructed_meshes_ValidationSubset.mat']);
    end

    if(~exist('iminfo_ValidationSubset', 'var'))
      load([OutputDir 'iminfo_ValidationSubset.mat']);
    end

    if(exist('matches_ValidationSubset','var')~=1)
        load([OutputDir 'matches_ValidationSubset.mat']);
    end

    for i=1:3
        val_video_dir = [path_to_Results_Validation '/' Experiment{i} '/Videos'];
        mkdir(val_video_dir);
        generateVideo(reconstructed_meshes_ValidationSubset{i,1}, ...
                      matches_ValidationSubset{i,1},iminfo_ValidationSubset{i},...
                      val_video_dir,VAL_SKIP);
    end
end

