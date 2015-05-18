function [deformation_data, error_msg] = runDeformationPipeline(matches,iminfo, ...
                                                   OutputDir,mode,varargin)

if(strcmp(mode,'trial'))
    batchSize = 12;
    numMatches = min(12, length(matches.testImages));
    minNum = 1;
    maxNum = numMatches;
elseif(strcmp(mode,'all'))
    batchSize = 12;
    numMatches = length(matches.testImages);
    minNum = 1;
    maxNum = numMatches;
elseif(size(varargin,2)>0)
        batchSize = varargin{1,1};
        minNum = varargin{1,2};
        maxNum = varargin{1,3};
        numMatches = varargin{1,4};
end

%% create a cell array for storing deformation data
deformation_data = cell(numMatches,1);
error_msg = cell(numMatches,1);

for i=minNum:batchSize:maxNum
    disp(['Batch Index: ' num2str(i)]);

    %% Initialize datastructure for split into cores
    key = cell(batchSize,1);
    depth_query = cell(batchSize,1);
    mesh_query = cell(batchSize,1);
    camera_query = cell(batchSize,1);
    depth_match = cell(batchSize,1);
    mesh_match = cell(batchSize,1);
    mesh_match_simp = cell(batchSize,1);
    camera_match = cell(batchSize,1);
    disp('Initialized datastructure');

    if(maxNum-i+1>=batchSize)
        batchSizeInner = batchSize;
    else
        batchSizeInner = maxNum-i+1;
    end

    for k=i:(i+batchSizeInner-1)
        coreIdx = k-i+1;
        [key{coreIdx,1},depth_query{coreIdx,1},mesh_query{coreIdx,1},...
         camera_query{coreIdx,1},depth_match{coreIdx,1},mesh_match{coreIdx,1},...
         mesh_match_simp{coreIdx,1},camera_match{coreIdx,1}]...
            = getMatchBestDist(matches,iminfo,k);
    end
    disp('Selected best matches');

    sub_error_msg = cell(batchSize,1);

    %% Run parallel jobs
    parfor j=1:batchSizeInner
        disp(['BatchIdx: ' num2str(i) ' CoreIdx: ' num2str(j)]);
        try
            sub_deformation_data{j} = ...
                deformationPipeline(key{j,1},depth_query{j,1},mesh_query{j,1},...
                depth_match{j,1},mesh_match{j,1},mesh_match_simp{j,1},...
                camera_query{j,1},camera_match{j,1});
            disp(['Done with ' num2str(j)]);
        catch err
            sub_error_msg{j} = getReport(err);
            disp(['error in ' num2str(j)]);
            % save('error_msg.mat','error_msg');
        end
    end

    disp('After parfor')
    for j = 1:batchSizeInner
        deformation_data{(i-1)+j,1} = sub_deformation_data{j};
        error_msg{(i-1)+j,1} = sub_error_msg{j};
    end
    disp('After deformation')
    %% Save data
    save([OutputDir 'tmpData/deformation_error_msg.mat'],'error_msg');

end
