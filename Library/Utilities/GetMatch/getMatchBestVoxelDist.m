function [key, query_depth, query_mesh, query_camera, match_depth, match_mesh, match_camera] = getMatchBestVoxelDist(matches, iminfo, testIndex)

key.index = testIndex;
query_depth = imread(matches.testImages{testIndex});
query_mesh = readMesh([matches.testImageRoot{testIndex} '/' ...
    matches.testImageObjName{testIndex} '/' ...
    matches.testImageMeshNumber{testIndex} '_out.off']);
query_camera = getCameraInfo(iminfo, ...
    matches.testImageRoot{testIndex}, ...
    matches.testImageObjName{testIndex}, ...
    matches.testImageMeshNumber{testIndex}, ...
    matches.testImageViewNumber{testIndex});

if(iscell(matches.testImgIdx))
    if(~isfield(matches, 'voxelIOU'))
        matches.voxelIOU = matches.IOU;
    end
    i = find(matches.voxelDist{testIndex} == min(matches.voxelDist{testIndex}));
    key.bestIdx = i(1);
    trainIndex = matches.testImgIdx{testIndex}(key.bestIdx);
else
    key.bestIdx = 1;
    trainIndex = matches.testImgIdx(testIndex);
end

match_depth = imread(matches.trainImages{trainIndex});
match_mesh = readMesh([matches.trainImageRoot{trainIndex} '/' ...
    matches.trainImageObjName{trainIndex} '/' ...
    matches.trainImageMeshNumber{trainIndex} '_out.off']);
match_camera = getCameraInfo(iminfo, ...
    matches.trainImageRoot{trainIndex}, ...
    matches.trainImageObjName{trainIndex}, ...
    matches.trainImageMeshNumber{trainIndex}, ...
    matches.trainImageViewNumber{trainIndex});

end
%%
function camera = getCameraInfo(iminfo, root, obj_name, mesh_number, view_number)
selection = strcmp(iminfo.root, root) & strcmp(iminfo.objName, obj_name) & strcmp(iminfo.meshNumber, mesh_number) & strcmp(iminfo.viewNumber, view_number);
if(sum(selection) <= 0)
	fprintf('%s/%s/%s\n', obj_name, mesh_number, view_number);
end
assert(sum(selection) > 0);
if(sum(selection) ~= 1)
    warning(['Duplicate Mesh-camera: ' obj_name '-' mesh_number '-' view_number]);
    v = find(selection,1);
    selection = false(size(selection));
    selection(v) = true;
end
camera = iminfo.camera{selection};
end

