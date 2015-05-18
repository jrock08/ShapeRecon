function [dist, time, sampleDist, sampleTime, samplePercent, relativeError, idx] = depthCompTest(matches, iminfo, count)

idx = randi(length(matches.testImages), 1, count);
p = Par(count);
parfor i = 1:count
    idx1 = idx(i);
    idx2 = matches.testImgIdx(idx1);

    query_depth = imread(matches.testImages{idx1});
    match_depth = imread(matches.trainImages{idx2});

    match_camera = getMeshCamera(iminfo, ...
        matches.trainImageObjName{idx2}, ...
        matches.trainImageMeshNumber{idx2}, ...
        matches.trainImageViewNumber{idx2});

    query_depth_pcl = pclFromDepthCamera(query_depth, match_camera);
    query_depth_pcl_sample = pclFromDepthCameraSample(query_depth, match_camera);

    match_depth_pcl = pclFromDepthCamera(match_depth, match_camera);
    match_depth_pcl_sample = pclFromDepthCameraSample(match_depth, match_camera);

    Par.tic;
    dist(i) = surfDist(query_depth_pcl, match_depth_pcl);
    t = Par.toc;
    time(i) = t.ItStop - t.ItStart;

    Par.tic;
    sampleDist(i) = surfDist(query_depth_pcl_sample, match_depth_pcl_sample);
    t = Par.toc;
    sampleTime(i) = t.ItStop - t.ItStart;

    samplePercent(i) = length(query_depth_pcl_sample) / length(query_depth_pcl);
    relativeError(i) = abs(sampleDist(i) - dist(i)) / dist(i);
end
stop(p);

fprintf('Full: %f, Partial: %f\n', mean(time), mean(sampleTime));
fprintf('Percent: %f, Error: %f\n', mean(samplePercent), mean(relativeError));

end

