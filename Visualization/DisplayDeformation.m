function DisplayDeformation(iminfo, deformations)
% Displays the mesh query, matched mesh, and deformed matched mesh


for idx = 21
idx
iminfo.images{deformations{idx}.key.index}

I = imread(iminfo.images{deformations{idx}.key.index});
figure, imshow(I);

mesh_query = deformations{idx}.mesh_query_world;
mesh_match = deformations{idx}.mesh_match;
mesh_deformed = deformations{idx}.mesh_match_deformed;

h = figure;
displayMesh(mesh_deformed);
input('type when done');
camera_position = campos();
close all;

figure;
displayMesh2(mesh_query)
campos(camera_position);
saveTightFigure(gcf, ['deformation_1_' num2str(idx) '.png'], '-dpng', '-r1000');

figure;
displayMesh2(mesh_match)
campos(camera_position);
saveTightFigure(gcf, ['deformation_2_' num2str(idx) '.png'], '-dpng', '-r1000');

figure;
displayMesh2(mesh_deformed)
campos(camera_position);
saveTightFigure(gcf, ['deformation_3_' num2str(idx) '.png'], '-dpng', '-r1000');

input('type when done');
close all;
end
end

