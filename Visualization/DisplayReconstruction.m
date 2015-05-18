function DisplayReconstruction(iminfo, reconstructions, matches, metrics, idx_in, prefix)
% Displays the query_mesh, deformed matched mesh, fully reconstructed mesh,
% and query pointcloud.


count = 1;

fid = fopen(['~/Dropbox/MoreReconstructions/' prefix '_numbers.txt'],'w');

fprintf(fid, 'baseline & match & deformed & reconstruct depth & reconstruct full')

for idx = idx_in
% idx
% iminfo.images{idx}
% 

if(exist(['~/Dropbox/MoreReconstructions/' prefix '_' num2str(count) '_mesh_query.png'], 'file'))
    count = count +1;
    continue;
end

query_info = queryIminfo(iminfo, matches.testImageObjName{idx}, matches.testImageMeshNumber{idx}, matches.testImageViewNumber{idx});
match_idx = matches.testImgIdx{idx}(reconstructions{idx}.key.bestIdx);
match_info = queryIminfo(iminfo, matches.trainImageObjName{match_idx}, matches.trainImageMeshNumber{match_idx}, matches.trainImageViewNumber{match_idx});

I_query = query_info.depth;%imread(iminfo.images{reconstructions{idx}.key.index});
%imwrite(I_query, ['~/Desktop/Pipeline/query_depthmap.png']);
imwrite(I_query, ['~/Dropbox/MoreReconstructions/' prefix '_' num2str(count) '_query_depthmap.png']);
figure, imshow(I_query);

I_match = match_info.depth;
%figure, imshow(I_match);
%imwrite(I_match, ['~/Desktop/Pipeline/match_depthmap.png']);
imwrite(I_match, ['~/Dropbox/MoreReconstructions/' prefix '_' num2str(count) '_match_depthmap.png']);

mesh_query = reconstructions{idx}.mesh_query_aligned;
mesh_deformed = reconstructions{idx}.mesh_match_deformed;
mesh_reconstruction = reconstructions{idx}.mesh_reconstructed_wsym;
mesh_reconstructed_wosym = reconstructions{idx}.mesh_reconstructed_wosym;
pcl = reconstructions{idx}.pcl_query;

[mesh_recon_flip, frontal_mesh] = get_symmetry_mesh(I_query, reconstructions{idx});



figure;
displayMesh(mesh_reconstructed_wosym);
axis equal;
input('type when done');
camera_position = campos();
close all;

figure;
displayMesh2(mesh_query);
campos(camera_position);
saveTightFigure(gcf, ['~/Dropbox/MoreReconstructions/' prefix '_' num2str(count) '_mesh_query.png'], '-dpng', '-r500');

figure, displayMesh2(frontal_mesh);
campos(camera_position);
saveTightFigure(gcf, ['~/Dropbox/MoreReconstructions/' prefix '_' num2str(count) '_frontal.png'], '-dpng', '-r500');

figure, displayMesh2(mesh_recon_flip);
campos(camera_position);
saveTightFigure(gcf, ['~/Dropbox/MoreReconstructions/' prefix '_' num2str(count) '_baseline.png'], '-dpng', '-r500');

figure, displayMesh2(reconstructions{idx}.mesh_match);
campos(camera_position);
saveTightFigure(gcf, ['~/Dropbox/MoreReconstructions/' prefix '_' num2str(count) 'mesh_matched.png'], '-dpng', '-r500');

figure;
displayMesh2(mesh_deformed);
campos(camera_position);
saveTightFigure(gcf, ['~/Dropbox/MoreReconstructions/' prefix '_' num2str(count) '_mesh_deformed.png'], '-dpng', '-r500');

figure, displayMesh2(mesh_reconstructed_wosym);
campos(camera_position);
saveTightFigure(gcf, ['~/Dropbox/MoreReconstructions/' prefix '_' num2str(count) '_mesh_reconstructed_wosym.png'], '-dpng', '-r500');

figure, displayMesh2(mesh_reconstruction);
campos(camera_position);
saveTightFigure(gcf, ['~/Dropbox/MoreReconstructions/' prefix '_' num2str(count) '_mesh_reconstructed_wsym.png'], '-dpng', '-r500');



[baseline_IOU, baseline_surfdist] = compute_metrics_error(I_query, reconstructions{idx}.camera_query ,mesh_query);

fprintf(fid, '%f & ', [baseline_IOU, metrics.voxelIOU(idx), metrics.voxelIOUDeformed(idx), metrics.voxelIOUReconstructedNoSym(idx), metrics.voxelIOUReconstructedSym(idx)]);
fprintf(fid, '\n');
fprintf(fid, '%f & ', [baseline_surfdist, metrics.surfaceDist(idx), metrics.surfaceDistDeformed(idx), metrics.surfaceDistReconstructedNoSym(idx), metrics.surfaceDistReconstructedSym(idx)]);


disp([num2str(baseline_IOU) ' & ' num2str(metrics.voxelIOU(idx)) ' & '  num2str(metrics.voxelIOUDeformed(idx)) ' & ' num2str(metrics.voxelIOUReconstructedNoSym(idx)) ' & ' num2str(metrics.voxelIOUReconstructedSym(idx))])
disp([num2str(baseline_surfdist) ' & ' num2str(metrics.surfaceDist(idx))  ' & ' num2str(metrics.surfaceDistDeformed(idx)) ' & ' num2str(metrics.surfaceDistReconstructedNoSym(idx)) ' & ' num2str(metrics.surfaceDistReconstructedSym(idx))]);

% figure;
% subsample = ceil(size(pcl,2)/10000);
% displayPCL2(pcl(:,1:subsample:end), pcl(2,1:subsample:end));
% campos(camera_position);
%saveTightFigure(gcf, ['~/Dropbox/reconstruction_' prefix '_' num2str(idx) '_5.png'], '-dpng', '-r500');

% figure;
% displayMesh2(mesh_query)
% campos(camera_position);
% saveTightFigure(gcf, ['deformation_1_' num2str(idx) '.png'], '-dpng', '-r1000');
% 
% figure;
% displayMesh2(mesh_match)
% campos(camera_position);
% saveTightFigure(gcf, ['deformation_2_' num2str(idx) '.png'], '-dpng', '-r1000');
% 
% figure;
% displayMesh2(mesh_deformed)
% campos(camera_position);
% saveTightFigure(gcf, ['deformation_3_' num2str(idx) '.png'], '-dpng', '-r1000');

%input('type when done');
%keyboard
close all;
count = count+1;
end
fclose(fid);

end


function [reflected_sym_mesh, frontal_only_mesh] = get_symmetry_mesh(depthmap_query, mesh)
    c.camera = mesh.camera_match;
    [M, P, V] = getCamera(mesh.camera_match);
    T = M(1:3,1:3);


    mesh_depthmap = ImagePlaneSymmetryVoxel(depthmap_query); %
                                                             % Baseline
    mesh_depthmap.v = InvertCamera(mesh_depthmap.v, M, P, V);

    mesh_sym_plane = mesh_depthmap.sym_plane;
    mesh_sym_plane.v = InvertCamera(mesh_sym_plane.v, M, P, V);

    mesh_front_depthmap = FrontalDepthmapMesh(depthmap_query); % pcl to mesh
    mesh_front_depthmap.v = InvertCamera(mesh_front_depthmap.v, M, ...
                                             P, V);
    s = mesh.coarse_s;
    R = mesh.coarse_R;
    t = mesh.coarse_t;
    reflected_sym_mesh.f = mesh_depthmap.f;
    reflected_sym_mesh.v = s*R*mesh_depthmap.v(1:3,:) + ...
        repmat(t,1,size(mesh_depthmap.v,2));

    frontal_only_mesh.f = mesh_front_depthmap.f;
    frontal_only_mesh.v = (s*R*mesh_front_depthmap.v(1:3,:) ...
                                       ...
        + repmat(t,1,size(mesh_front_depthmap.v,2)));
    
end



function [voxelIOU, surfaceDist] = compute_metrics_error(query_depth, query_camera, query_mesh)
query_voxel = voxelizeMesh(query_mesh, query_camera);
query_pcl = surfacePCLMesh(query_mesh, query_camera);

% Jason's magic
mesh_depth = ImagePlaneSymmetryVoxel(query_depth);
[M,P,V] = getCamera(struct('camera', query_camera));
mesh_depth.v = InvertCamera(mesh_depth.v, M, P, V);
mesh_depth.v = mesh_depth.v(1:3,:);
baseline_voxel = voxelizeMesh(mesh_depth, query_camera);
baseline_pcl = surfacePCLMesh(mesh_depth, query_camera);

voxelIOU = VoxelIOUScore(query_voxel, baseline_voxel);
surfaceDist = surfDist(query_pcl, baseline_pcl);
end


function displayPCL2(pcl, d)
% [X,Y,Z] = sphere();
% X = X./100;
% Y = Y./100;
% Z = Z./100;
%figure, hold on;

% for i = 1:10:size(pcl,2) 
%     surf(X+pcl(1,i),Y+pcl(2,i),Z+pcl(3,i), 'FaceColor', [.4, .4, .4], ...
%         'EdgeColor', 'none', 'facelighting', 'phong', 'AmbientStrength', .3, 'SpecularStrength', .1);
% end

color = .5*(d-min(d))/(max(d)-min(d))+.5;%(pcl(1,:)-min(pcl(1,:)))./(max(pcl(1,:))-min(pcl(1,:)));
%plot3(pcl(1,1:10:end), pcl(2,1:10:end), pcl(3,1:10:end), '.', '[], 1-color(1:10:end), '.');
scatter3(pcl(1,1:end), pcl(2,1:end), pcl(3,1:end),[], 1-color(1:end),'.');%, 'lighting', 'phong', 'AmbientStrength', .3, 'SpecularStrength', .1);
    axis equal;
    axis([-2,2,-2,2,-2,2]);
    axis off;
%     light('Position', [-4, -4, 8], 'color', [.85, .8, 1]);
%     light('Position', [4, 4, 8], 'color', [.85, .8, 1]);
%     light('Position', [0, -4, 0], 'color', [.85, .8, 1]);
    colormap('gray');
    view(3);
end

