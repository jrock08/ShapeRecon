function [query_info, match_info] = VisualizeError(matches, iminfo, i)
    close all;
    fprintf('Index: %d, Silhouete IOU: %f, Voxel IOU: %f, Surface Distance: %f\n', ...
        i, matches.silhouetteIOU(i), matches.IOU(i), matches.surfaceDist(i));
    VisualizeSilhouetteError(matches, i);
    VisualizeVoxelError(matches, iminfo, i);
    VisualizeSurfaceError(matches, iminfo, i);
    [query_info, match_info] = getInfo(matches, iminfo, i);
end
%%
function VisualizeSilhouetteError(matches, i)
    query = imread(matches.testImages{i});
    match = imread(matches.trainImages{matches.testImgIdx(i)});
    figure;
    imshow([query, match]);
    query = imresize(query, .5) < 255;
    match = imresize(match, .5) < 255;
    intersection = query & match;
    error = cat(3, query - intersection, intersection, match - intersection);
    fig = figure;
    imshow(error);
    saveas(fig, 'depth.png');
end
%%
function VisualizeVoxelError(matches, iminfo, i)
    [query_camera, query_mesh] = getMeshCamera(iminfo, ...
        matches.testImageObjName{i}, ...
        matches.testImageMeshNumber{i}, ...
        matches.testImageViewNumber{i});
    i = matches.testImgIdx(i);
    [match_camera, match_mesh] = getMeshCamera(iminfo, ...
        matches.trainImageObjName{i}, ...
        matches.trainImageMeshNumber{i}, ...
        matches.trainImageViewNumber{i});
    %match_camera.position(1:2) = match_camera.position(1:2)*-1;

    query_voxel = voxelizeMesh(query_mesh, query_camera);
    match_voxel = voxelizeMesh(match_mesh, match_camera);
    sum(query_voxel(:))
    sum(match_voxel(:))
    iou = sum(query_voxel(:) & match_voxel(:)) / sum(query_voxel(:) | match_voxel(:))

    intersection = query_voxel & match_voxel;
    query_voxel = query_voxel - intersection;
    match_voxel = match_voxel - intersection;

    [y1,x1,~] = find(query_voxel);
    z1 = ceil(x1 / size(query_voxel, 3));
    x1 = mod(x1, size(query_voxel, 3));

    [y2,x2,~] = find(intersection);
    z2 = ceil(x2 / size(intersection, 3));
    x2 = mod(x2, size(intersection, 3));

    [y3,x3,~] = find(match_voxel);
    z3 = ceil(x3 / size(match_voxel, 3));
    x3 = mod(x3, size(match_voxel, 3));

    x = [x1(:);x2(:);x3(:)];
    y = [y1(:);y2(:);y3(:)];
    z = [z1(:);z2(:);z3(:)];
    c = [ones(length(x1), 1); ones(length(x2), 1)*2; ones(length(x3), 1)*3];
    fig = figure;
    scatter3(x,y,z,1,c,'filled');
    view(0,0)
    axis equal;
    axis off;

end
%%
function VisualizeSurfaceError(matches, iminfo, i)
    [query_camera, query_mesh] = getMeshCamera(iminfo, ...
        matches.testImageObjName{i}, ...
        matches.testImageMeshNumber{i}, ...
        matches.testImageViewNumber{i});
    i = matches.testImgIdx(i);
    [match_camera, match_mesh] = getMeshCamera(iminfo, ...
        matches.trainImageObjName{i}, ...
        matches.trainImageMeshNumber{i}, ...
        matches.trainImageViewNumber{i});
    %match_camera.position(1:2) = match_camera.position(1:2)*-1;

    query_pcl = surfacePCLMesh(query_mesh, query_camera);
    match_pcl = surfacePCLMesh(match_mesh, match_camera);
    pts = [query_pcl, match_pcl];

    c = [ones(1, length(query_pcl)), ones(1, length(match_pcl))*2];
    fig = figure;
    scatter3(pts(1,:), pts(2,:), pts(3,:),1,c,'filled');
    axis equal;
    axis off;

end
%%
function [query, match] = getInfo(matches, iminfo, i)
	queryIdx = strcmp(iminfo.objName, matches.testImageObjName{i}) ...
        & strcmp(iminfo.meshNumber, matches.testImageMeshNumber{i}) ...
        & strcmp(iminfo.viewNumber, matches.testImageViewNumber{i});
    trainIdx = matches.testImgIdx(i);
    matchIdx = strcmp(iminfo.objName, matches.trainImageObjName{trainIdx}) ...
        & strcmp(iminfo.meshNumber, matches.trainImageMeshNumber{trainIdx}) ...
        & strcmp(iminfo.viewNumber, matches.trainImageViewNumber{trainIdx});

    query.objName = iminfo.objName{queryIdx};
    query.meshNumber = iminfo.meshNumber{queryIdx};
    query.viewNumber = iminfo.viewNumber{queryIdx};
    [query.camera, query.mesh] = getMeshCamera(iminfo, query.objName, query.meshNumber, query.viewNumber);
    query.depth = imread(matches.testImages{i});

    match.objName = iminfo.objName{matchIdx};
    match.meshNumber = iminfo.meshNumber{matchIdx};
    match.viewNumber = iminfo.viewNumber{matchIdx};
    [match.camera, match.mesh] = getMeshCamera(iminfo, match.objName, match.meshNumber, match.viewNumber);
    match.depth = imread(matches.trainImages{matches.testImgIdx(i)});
end
