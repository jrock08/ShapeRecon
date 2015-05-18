setup_shape_reconstruction;

% check_iminfo(OutputDir,path_to_Test,'Test',TEST_FORCE_CREATE_IMINFO);
if(TEST_USE_SUBSET)
    check_iminfo(OutputDir, path_to_TestSubset, ...
        'TestSubset', TEST_FORCE_CREATE_IMINFO, 'segmented');
else
    check_iminfo(OutputDir, path_to_Test, ...
        'Test', TEST_FORCE_CREATE_IMINFO, 'segmented');
end

%% Concatenate Train and TestSubset
if(exist([OutputDir 'iminfo_Train_TestSubset.mat'],'file')~=2)
    load([OutputDir 'iminfo_Train.mat']);
    load([OutputDir 'iminfo_TestSubset.mat'])
    iminfo_Train_TestSubset = struct_concat(iminfo_Train, ...
                                                  iminfo_TestSubset{1,1}, ...
                                                  iminfo_TestSubset{2,1}, ...
                                                  iminfo_TestSubset{3,1});
    save([OutputDir 'iminfo_Train_TestSubset.mat'], 'iminfo_Train_TestSubset','-v7.3');
end

%% Run matching on TestSubset
if(TEST_RUN_MATCH_TESTSUBSET)
    if(exist('RF_Model_Train','var')~=1)
        load([OutputDir 'RF_Model_Train']);
    end
    if(exist('iminfo_TestSubset','var')~=1)
        load([OutputDir 'iminfo_TestSubset.mat']);
    end
    if(exist('iminfo_Train_TestSubset','var')~=1)
        load([OutputDir 'iminfo_Train_TestSubset.mat']);
    end

    matches_TestSubset = cell(3,1);
    for i=1:3
        [ matches_TestSubset{i,1} ] = test_RF(RF_Model_Train, ...
                                                    iminfo_TestSubset{i,1}, 1000, TEST_PIPELINE_MODE);

        % Compute Metrics for these matches
        matches_TestSubset{i,1} = computeMetricsMultiple(matches_TestSubset{i,1}, ...
                                                  iminfo_Train_TestSubset);
    end
    save([OutputDir 'matches_TestSubset.mat'], 'matches_TestSubset','-v7.3');
end

%% Run deformation pipeline on TestSubset
if(TEST_RUN_DEFORMATION_PIPELINE)
    if(exist('matches_TestSubset','var')~=1)
        load([OutputDir 'matches_TestSubset.mat']);
    end
    if(exist('iminfo_TestSubset','var')~=1)
        load([OutputDir 'iminfo_TestSubset.mat']);
    end
    if(exist('iminfo_Train_TestSubset','var')~=1)
        load([OutputDir 'iminfo_Train_TestSubset']);
    end

    deformation_TestSubset = cell(3,1);
    for i=1:3
        deformation_TestSubset{i,1} = runDeformationPipeline(matches_TestSubset{i,1},...
                                                      iminfo_Train_TestSubset,...
                                                      OutputDir, TEST_PIPELINE_MODE);
    end

    save([OutputDir 'deformation_TestSubset.mat'], ...
         'deformation_TestSubset', '-v7.3');
end

%% Run reconstruction on TestSubset
if(TEST_RECONSTRUCTION)
    if(exist('deformation_TestSubset','var')~=1)
        load([OutputDir 'deformation_TestSubset.mat']);
    end
    if(exist('matches_TestSubset','var')~=1)
        load([OutputDir 'matches_TestSubset.mat']);
    end

    load([OutputDir 'voxel_classifier_' FEATURE_TYPE '/voxel_classifier_model.mat']);
    voxel_classifier = createVoxelClassifier(voxel_classifier_model, OutputDir, ...
                                             FEATURE_TYPE, ...
                                             CLASSIFIER_TYPE, BIAS);
    for i=1:3
        [reconstructed_meshes_TestSubset{i,1}] = ...
            reconstruct_shape(deformation_TestSubset{i,1}, ...
            voxel_classifier, matches_TestSubset{i,1});
    end
    save([OutputDir 'reconstructed_meshes_TestSubset.mat'],'reconstructed_meshes_TestSubset','-v7.3');
end

%% Run computer metrics on reconstruction on TestSubset
if(TEST_COMPUTE_METRICS)
    if(exist('reconstructed_meshes_TestSubset','var')~=1)
        load([OutputDir 'reconstructed_meshes_TestSubset']);
    end

    metrics_reconstruction_TestSubset = cell(3,1);
    for i = 1:3
         metrics_reconstruction_TestSubset{i,1} = ...
             computeMetricsDeformed(reconstructed_meshes_TestSubset{i,1});
    end
    save([OutputDir 'metrics_reconstruction_TestSubset.mat'], ...
         'metrics_reconstruction_TestSubset');
end

%% Run Image Generation
if(TEST_IMAGE_GENERATION)
    if(exist('reconstructed_meshes_TestSubset','var')~=1)
        load([OutputDir 'reconstructed_meshes_TestSubset.mat']);
    end

    if(exist('iminfo_TestSubset','var')~=1)
        load([OutputDir 'iminfo_TestSubset.mat']);
    end
    if(exist('matches_TestSubset','var')~=1)
        load([OutputDir 'matches_TestSubset.mat']);
    end

    for i=1:3
        test_image_dir = [path_to_Results_Test '/' Experiment{i} '/Images'];
        mkdir(test_image_dir);
        generateImage(reconstructed_meshes_TestSubset{i,1}, ...
                      matches_TestSubset{i,1},iminfo_TestSubset{i},test_image_dir,TEST_SKIP);
    end
end

%% Run Video Generation
if(TEST_VIDEO_GENERATION)
    if(exist('reconstructed_meshes_TestSubset','var')~=1)
        load([OutputDir 'reconstructed_meshes_TestSubset.mat']);
    end

    if(exist('iminfo_TestSubset','var')~=1)
        load([OutputDir 'iminfo_TestSubset.mat']);
    end

    if(exist('matches_TestSubset','var')~=1)
        load([OutputDir 'matches_TestSubset.mat']);
    end

    for i=1:3
        test_video_dir = [path_to_Results_Test '/' Experiment{i} '/Videos'];
        mkdir(test_video_dir);
        generateVideo(reconstructed_meshes_TestSubset{i,1}, ...
                      matches_TestSubset{i,1}, iminfo_TestSubset{i}, test_video_dir,TEST_SKIP);
    end
end
