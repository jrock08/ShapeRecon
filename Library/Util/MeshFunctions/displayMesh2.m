function displayMesh2(mesh)
    patch('Faces', mesh.f', 'Vertices', mesh.v(1:3,:)', 'FaceColor', [.4, .4, .4], ...
        'EdgeColor', 'none', 'facelighting', 'phong', 'AmbientStrength', .5, 'SpecularStrength', .2);
    axis equal;
    axis([-2,2,-2,2,-2,2]);
    axis off;
    light('Position', [-4, -4, 8], 'color', [1, 1, 1]);
    light('Position', [4, 4, 8], 'color', [1, 1, 1]);
    light('Position', [0, -4, 0], 'color', [1, 1, 1]);
    view(3);
end