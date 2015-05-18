function [ ] = VisualizeDepthmap( iminfo )
% Displays the displays the frontal mesh, ground truth mesh, and pointcloud.

view_params = [10,20];

idx = 10000;

iminfo.images{idx}

depthmap = imread(iminfo.images{idx});
[M,P,V] = getCamera(iminfo.camera{idx});
mesh_gt = readMesh(iminfo.meshes{idx});

[pcl,d] = pclFromDepthCamera(depthmap, iminfo.camera{idx});
h = figure;
displayPCL2(pcl, d);
hold on;
displayMesh(mesh_gt);
input('type when done');
%inputdlg('click when done setting camera');
camera_position = campos();
close(h)


mesh = FrontalDepthmapMesh(depthmap);
mesh.v = InvertCamera(mesh.v, M, P, V);
figure, displayMesh2(mesh);
campos(camera_position)
saveTightFigure(gcf, ['out_1_' num2str(idx) '.png'], '-dpng', '-r1000');

figure, displayMesh2(mesh_gt);
campos(camera_position);
saveTightFigure(gcf, ['out_2_' num2str(idx) '.png'], '-dpng', '-r1000');

figure,displayPCL2(pcl,d); hold on;
displayMesh(mesh_gt);
campos(camera_position);
saveTightFigure(gcf, ['out_3_' num2str(idx) '.png'], '-dpng', '-r1000');

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
