function [ iminfo ] = CreateImInfo( rootdir, sparse )
% rootdir contains objectname/D****

if(nargin < 2)
    sparse = false;
end

d = dir(rootdir);

iminfo.images = {};
iminfo.names = {};
iminfo.camera = {};
iminfo.meshes = {};
iminfo.masks = {};
iminfo.meshes_simp = {};

for i = 1:length(d)
    if(strcmp(d(i).name(1),'.') || ~isdir([rootdir filesep d(i).name]))
       continue;
    end

    classdir = [rootdir filesep d(i).name];

    d2 = dir([classdir filesep '*_out.txt']);

    for j = 1:length(d2)
        MeshId = d2(j).name(1:end-12)
        CameraTextFile = [classdir filesep MeshId '.off_out.txt'];
        cameras = readFile(CameraTextFile);

        mesh_file = [classdir filesep MeshId '_out.off'];
        mesh_simp_file = [classdir filesep MeshId '_out_simp.off'];
        if (~exist(mesh_file, 'file'))
            warning(['mesh does not exist at: ' mesh_file '\n skipping'])
            continue;
        end

        if (~exist(mesh_simp_file, 'file'))
          mesh_orig = readMesh(mesh_file);
          if(numel(mesh_orig.f)/3 > 10000)
            mesh_simp = simplifyMesh(readMesh(mesh_file));
            writeMesh(mesh_simp, mesh_simp_file);
          else
            mesh_simp_file = mesh_file;
          end
        end
        for k = 1:numel(cameras)
            image = [classdir filesep MeshId '.off_v' num2str(k-1) '_depth.png'];

            if(~exist(image, 'file'))
                if(~sparse)
                    warning(['image does not exist at: ' image])
                end
                continue;
            end

            mask_file = [classdir filesep MeshId '.off_v' num2str(k-1) '_mask.png'];
            if(~exist(mask_file, 'file'))
              mask = imread(image)~=255;
              imwrite(mask, mask_file);
            end

            iminfo.camera{end+1} = cameras{k}.camera;
            iminfo.images{end+1} = image;
            iminfo.names{end+1} = [d(i).name filesep MeshId];
            iminfo.meshes{end+1} = mesh_file;
            iminfo.meshes_simp{end+1} = mesh_simp_file;
            iminfo.masks{end+1} = mask_file;
        end
    end

end

