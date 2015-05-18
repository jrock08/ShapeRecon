function matches = computeMetricsMultiple(matches, iminfo)
% Input
% matches - a struct containing testImages, trainImages, testImgIdx
% iminfo - a struct containing info on the meshes, cameras, and images for
% matches.
%
% Ouput
% matches - same matches input struct with metrics attached.

% For each query
parfor i = 1:length(matches.testImages)
    [depthDist{i}] = computeMetricInnerParallel(matches,iminfo,i);
end
matches.depthDist = depthDist;
end

%%
function [depthDist] = computeMetricInnerParallel(matches,iminfo,i)
fprintf('Computing Metrics for Match %d/%d\n', i, length(matches.testImages));

query_info_struct = queryIminfo(iminfo, ...
        matches.testImageObjName{i}, ...
        matches.testImageMeshNumber{i}, ...
        matches.testImageViewNumber{i});

% For each potential match
for j = 1:length(matches.testImgIdx{i})
    match_idx = matches.testImgIdx{i}(j);
    match_info_struct = queryIminfo(iminfo, ...
            matches.trainImageObjName{match_idx}, ...
            matches.trainImageMeshNumber{match_idx}, ...
            matches.trainImageViewNumber{match_idx});

    query_depth_pcl = pclFromDepthCameraSample(query_info_struct.depth,...
        query_info_struct.mask, match_info_struct.camera);
    match_depth_pcl = pclFromDepthCameraSample(match_info_struct.depth,...
        match_info_struct.mask, match_info_struct.camera);

    % Compute metrics
    depthDist(j) = surfDist(query_depth_pcl, match_depth_pcl);
end
end
