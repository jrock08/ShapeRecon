function [key, query_depth, query_mesh, query_camera, match_depth, match_mesh, match_mesh_simp, match_camera] = getMatchBestDist(matches, iminfo, testIndex)

key.index = testIndex;

query_iminfo_struct = queryIminfo(iminfo, ...
    matches.testImageObjName{testIndex}, ...
    matches.testImageMeshNumber{testIndex}, ...
    matches.testImageViewNumber{testIndex});
query_depth = query_iminfo_struct.depth;
query_mesh = query_iminfo_struct.mesh;
query_camera = query_iminfo_struct.camera;

if(iscell(matches.testImgIdx))
    if(~isfield(matches, 'depthDist') || length(matches.depthDist{testIndex}) ~= length(matches.testImgIdx{testIndex}))
        matches.depthDist{testIndex} = computeDepthDist(matches, iminfo, testIndex);
    end
    i = find(matches.depthDist{testIndex} == min(matches.depthDist{testIndex}));
    key.bestIdx = i(1);
    trainIndex = matches.testImgIdx{testIndex}(key.bestIdx);
else
    key.bestIdx = 1;
    trainIndex = matches.testImgIdx(testIndex);
end

match_iminfo_struct = queryIminfo(iminfo, ...
    matches.trainImageObjName{trainIndex}, ...
    matches.trainImageMeshNumber{trainIndex}, ...
    matches.trainImageViewNumber{trainIndex});

match_depth = match_iminfo_struct.depth;
match_mesh = match_iminfo_struct.mesh;
match_mesh_simp = match_iminfo_struct.mesh_simp;
match_camera = match_iminfo_struct.camera;

end

%%
function depthDist = computeDepthDist(matches, iminfo, testIndex)
    query_depth = imread(matches.testImages{testIndex});
    for i = 1:length(matches.testImgIdx{testIndex})
        trainIndex = matches.testImgIdx{testIndex}(i);
        match_depth = imread(matches.trainImages{trainIndex});
        match_camera = getMeshCamera(iminfo, ...
            matches.trainImageRoot{trainIndex}, ...
            matches.trainImageObjName{trainIndex}, ...
            matches.trainImageMeshNumber{trainIndex}, ...
            matches.trainImageViewNumber{trainIndex});
        query_depth_pcl = pclFromDepthCameraSample(query_depth, match_camera);
        match_depth_pcl = pclFromDepthCameraSample(match_depth, match_camera);
        depthDist(i) = surfDist(query_depth_pcl, match_depth_pcl); 
    end 
end

