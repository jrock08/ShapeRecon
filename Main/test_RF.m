function [matches] = test_RF(rfModel, iminfo, testSize, pipeline_mode)
% Trains random forest with given model
% inputs
%   rfModel - Random forest model
%   iminfo - information of images to test the random forest with
%   testSize (optional) - Number of images to batch-test
if nargin < 3
    testSize = 1000;
end

if nargin < 4
  pipeline_mode = 'all';
end


reset_rng = rng();
rng(10394);

if(strcmp(pipeline_mode, 'trial'))
  testImages = iminfo.images(1:12);
else
  testImages = iminfo.images;
end


% Test vocab tree.
disp('Testing random forest');
test_num = floor(length(testImages) / testSize) + 1;
testImgsSet = cell(test_num, 1);
for i=1:test_num
    minIdx = (i-1)*testSize+1;
    maxIdx = min((i*testSize), length(testImages));
    testImgsSet{i} = testImages(minIdx:maxIdx);
end
testResults = cell(test_num, 1);
parfor i=1:test_num
    set(0,'RecursionLimit', 2000);
    minIdx = (i-1)*testSize+1;
    maxIdx = min((i*testSize), length(testImages));
    fprintf('Testing from %d to %d\n', minIdx, maxIdx);
    testResults{i} = forestTest(rfModel.tree, testImgsSet{i});
end
testResult = [];
for i=1:test_num
    testResult = vertcat(testResult, testResults{i});
end
testImgIdx = restrictMatch(testResult);
matches.testImages = testImages;
matches.testImgIdx = testImgIdx;
matches.trainImages = rfModel.trainImages;

matches = parse_matches(matches);

rng(reset_rng);
