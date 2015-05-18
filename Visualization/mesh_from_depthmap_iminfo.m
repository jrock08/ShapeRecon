for i = 1:numel(iminfo.images)
    images = imread(iminfo.images{i});
    meshes = readMesh(iminfo.meshes{i});
    camera = iminfo.camera{i};

    [M,P,V] = getCamera(struct('camera', camera));
    [mesh_v, mesh_p, mesh_r] = ApplyCamera(meshes, M, P, V);

    mesh_depthmap = ImagePlaneSymmetryVoxel(images);
    mesh_depthmap.v = InvertCamera(mesh_depthmap.v, M, P, V);

    mesh_sym_plane = mesh_depthmap.sym_plane;
    mesh_sym_plane.v = InvertCamera(mesh_sym_plane.v, M, P, V);

    mesh_front_depthmap = ImagePlaneSymmetry(images, camera);
    mesh_front_depthmap.v = InvertCamera(mesh_front_depthmap.v, M, P, V);

    f = figure('visible', 'off');
    ax1 = subplot(1,3,1);
    displayMesh2(meshes);
    hold on;
    displayMesh3(mesh_sym_plane);
    ax2 = subplot(1,3,2);
    displayMesh2(mesh_depthmap);
    hold on;
    displayMesh3(mesh_sym_plane);
    ax3 = subplot(1,3,3);
    displayMesh2(mesh_front_depthmap);
    hold on;
    displayMesh3(mesh_sym_plane);


    Link = linkprop([ax1, ax2, ax3], {'CameraUpVector', 'CameraPosition', 'CameraTarget'});
    setappdata(gcf, 'StoreTheLink', Link);
    view(3);

    savefig(f, ['figures/figure_' num2str(i)]);
    saveTightFigure(f, ['figures/figure_' num2str(i) '.eps']);
    close(f);
end
