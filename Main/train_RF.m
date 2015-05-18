function [RF_model] = train_RF(iminfo, conf)
% Trains random forest model
% inputs
%   iminfo - information of images to train the random forest with
%   conf (optional) - struct with the following configuration info
%     outputDir - directory where voxel informations are saved
%     trainVoxelMat - pre-computed voxel mat file
%     trainVoxelFeatMat - pre-computed nnmf mat file
%     train3DEntropy - if true calculate entropy based on voxels
%     trainVoxelSize - 1 dimension size of the voxel
%     nnmfSampleNum - number of images to sample to build nnmf
%     nnmfFeatureNum - number of dimension of nnmf
%     randomSeed - random seed
if nargin < 2
    conf = {};
end

% default values
if ~isfield(conf, 'outputDir') 
    conf.outputDir = '';
end
if ~isfield(conf, 'trainVoxelMat')
    conf.trainVoxelMat = 'trainVoxel.mat';
end
if ~isfield(conf, 'trainVoxelFeatMat')
    conf.trainVoxelFeatMat = 'trainVoxelFeatures.mat';
end
if ~isfield(conf, 'train3DEntropy')
    conf.train3DEntropy = 1;
end
if ~isfield(conf, 'trainVoxelSize')
    conf.trainVoxelSize = 50;
end
if ~isfield(conf, 'nnmfSampleNum')
    conf.nnmfSampleNum = 2700;
end
if ~isfield(conf, 'nnmfFeatureNum')
    conf.nnmfFeatureNum = 50;
end
if ~isfield(conf, 'randomSeed')
    conf.randomSeed = 1234;
end

% Set up environment
rng(conf.randomSeed); % random seed

trainImages = iminfo.images;
conf.nnmfSampleNum = min(conf.nnmfSampleNum, numel(trainImages));

voxelMat = fullfile(conf.outputDir, conf.trainVoxelMat);
voxelFeatureMat = fullfile(conf.outputDir, conf.trainVoxelFeatMat);

% Prepare 3D features to calculate entropy from
W = [];
if conf.train3DEntropy
    disp('Preparing 3D features to calculate entropy from');
    if exist(voxelFeatureMat, 'file') == 2
        load(voxelFeatureMat); % precomputed 3d feature
    else
        if exist(voxelMat, 'file') == 2
            load(voxelMat); % precomputed voxels
        else
            % Voxelize all train images
            trainVoxelCells = voxelizeAllImgs(iminfo, trainImages, ...
                                              conf.trainVoxelSize);
            % Vectorize cell
            trainVoxels = false(length(trainVoxelCells), ...
                                conf.trainVoxelSize.^3);
            for i=1:length(trainVoxelCells)
                trainVoxels(i, :) = trainVoxelCells{i}(:);
            end
            save(voxelMat, 'trainVoxels');
        end
        % Run nnmf factorization
        sampleVoxels = single(trainVoxels(randperm(size(trainVoxels, 1), ...
                              conf.nnmfSampleNum), :));
        [~, H] = nnmf(sampleVoxels, conf.nnmfFeatureNum, 'options', ...
                      statset('Display', 'iter'));
        % Project voxels to H
        W = zeros(size(trainVoxels, 1), size(H, 1));
        parfor i=1:size(trainVoxels, 1)
            W(i, :) = (lsqnonneg((double(H).'), ...
                       (double(trainVoxels(i, :)).'))).';
        end
        save(voxelFeatureMat, 'trainVoxels', 'H', 'W');
    end
end

% Train random forest.
disp('Training random forest');
T = forestTrain(trainImages, W, struct('numTrees', 5));

RF_model.tree = T;
RF_model.trainImages = trainImages;
