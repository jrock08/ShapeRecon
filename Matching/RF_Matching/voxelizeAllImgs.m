function [voxels] = voxelizeAllImgs(iminfo, images, voxelScale)

    imgSize = size(images, 2);

    voxels = cell(1, imgSize);
    parfor i=1:imgSize
        disp(i);
        [~, objName, meshNum, viewNum]= parsePath(images{i});
        idx = getImInfoIndex(iminfo, objName, meshNum, viewNum);

        mesh = readMesh(iminfo.meshes{idx});
        camera = iminfo.camera{idx};
        voxels{i} = voxelizeMesh(mesh, camera, voxelScale);
    end

end
