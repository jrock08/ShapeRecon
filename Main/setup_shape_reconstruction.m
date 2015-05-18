%% Set up experiment
Experiment = {'NovelClass','NovelModel','NovelView'};

%% Set up path
baseDir = [pwd '/..'];

addpath(genpath([baseDir '/Library']));
addpath(genpath([baseDir '/ThirdParty']));
addpath(genpath([baseDir '/Matches']));
addpath(genpath([baseDir '/Matching']));
addpath(genpath([baseDir '/Visualization']));

%% Set up workspace
[DataDir, OutputDir] = get_data_dir_output_dir(baseDir);
if(~exist(OutputDir, 'dir'))
    mkdir(OutputDir);
end

%% Specify paths to data
path_to_Train1 = {[DataDir '/Train1']};
path_to_Train2 = cell(1,3);
path_to_Train2Subset = cell(1,3);
path_to_Validation = cell(1,3);
path_to_ValidationSubset = cell(1,3);
path_to_Test = cell(1,3);
path_to_TestSubset = cell(1,3);
for i=1:3
    path_to_Train2{1,i} = [DataDir '/Train2/' Experiment{i}];
    path_to_Train2Subset{1,i} = [DataDir '/Train2Subset/' Experiment{i}];
    path_to_Validation{1,i} = [DataDir '/Validation/' Experiment{i}];
    path_to_ValidationSubset{1,i} = [DataDir '/ValidationSubset/' Experiment{i}];
    path_to_Test{1,i} = [DataDir '/Test/' Experiment{i}];
    path_to_TestSubset{1,i} = [DataDir '/TestSubset/' Experiment{i}];
end
path_to_Train = [path_to_Train1, path_to_Train2];

%% Set up directories for storing sharded reconstructed meshes
path_to_Reconstruction_Sharded = [OutputDir ...
                    'Reconstruction_Sharded'];

%% Set up directories to save images and videos
path_to_Results_Validation = [OutputDir 'Results_Validation'];
path_to_Results_Test = [OutputDir 'Results_Test'];

mkdir([OutputDir 'tmpData']);
mkdir(path_to_Results_Validation);
mkdir(path_to_Results_Test);
mkdir(path_to_Reconstruction_Sharded);

for i = 1:3
    mkdir([OutputDir 'Results_Validation/' Experiment{i}]);
    mkdir([OutputDir 'Results_Test/' Experiment{i}])
end

%% Set up pipeline logs

mkdir([OutputDir '/logs/']);
diary([OutputDir '/logs/' datestr(clock, 0) '.txt' ]);
diary on;

%% Set the type of voxel classifier to use
% Options - 
% 'LR' - Logistic Regression
% 'BDT' - Boosted Decision Tree
% 'AUTOCONTEXT' - Appends the features with autocontext features
CLASSIFIER_TYPE = 'BDT';

%% Set the type of features to use while training voxel classifier
% Options - 
% 'BASIC' - basic 4 features
% 'SIMILARITY' - basic 4 + similarity measure
FEATURE_TYPE = 'SIMILARITY';

%% The bias for the classifier
if(strcmp(CLASSIFIER_TYPE,'BDT') && strcmp(FEATURE_TYPE,'SIMILARITY'))
    BIAS = 0.8
elseif (strcmp(CLASSIFIER_TYPE,'LR') && strcmp(FEATURE_TYPE,'SIMILARITY'))
    BIAS = 1.8
else
    BIAS = 0.8
end

% Pipeline modes available - 'trial','all'

%% Flags for train
TRAIN_USE_SUBSET = true;
TRAIN_FORCE_CREATE_IMINFO = false;
TRAIN_RF_TRAIN1 = false;
TRAIN_RF_TRAIN = false;
TRAIN_RUN_MATCH_TRAIN2SUBSET = false;
TRAIN_RUN_DEFORMATION_PIPELINE = false;
TRAIN_PIPELINE_MODE = 'trial';
TRAIN_EXTRACT_FEATURES = false;
TRAIN_VOXEL_CLASSIFIER = true;


%% Flags for Validation
VAL_LINESEARCH_FOR_BIAS = false;

VAL_USE_SUBSET = true;
VAL_FORCE_CREATE_IMINFO = true;
VAL_RUN_MATCH_VALSUBSET = true;
VAL_RUN_DEFORMATION_PIPELINE = true;
VAL_PIPELINE_MODE = 'trial';
VAL_RECONSTRUCTION = true;
VAL_COMPUTE_METRICS = true;
VAL_IMAGE_GENERATION = false;
VAL_VIDEO_GENERATION = false;
VAL_SKIP = 10;

%% Flags for Test
TEST_USE_SUBSET = true;
TEST_FORCE_CREATE_IMINFO = false;
TEST_RUN_MATCH_TESTSUBSET = true;
TEST_RUN_DEFORMATION_PIPELINE = true;
TEST_PIPELINE_MODE = 'trial';
TEST_RECONSTRUCTION = true;
TEST_COMPUTE_METRICS = true;
TEST_IMAGE_GENERATION = false;
TEST_VIDEO_GENERATION = false;
TEST_SKIP = 50;


%% Dependencies, by default Poisson Reconstruction is not used, uncomment if
%% using Poisson Reconstruction.
%if exist('poissonRecon') ~= 3;
%    error(['poissonRecon MEX file not found. It needs to be compiled. Run:'...
%    sprintf('\n%s/Library/reconstruction/poisson/cpp/scripts/build.sh', baseDir)]);
%end
