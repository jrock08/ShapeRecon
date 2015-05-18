function displayMesh3(mesh)
    patch('Faces', mesh.f', 'Vertices', mesh.v(1:3,:)', 'FaceColor', [.8, .5, .5], ...
        'EdgeColor', 'none', 'FaceAlpha', .4);
end