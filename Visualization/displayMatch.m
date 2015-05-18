function displayMatch(data, out)   
    close all;
    h = figure;
    
    subplot(1,2,1);
    showMesh(data.query_mesh, data.query_camera);
    
    
    subplot(1,2,2);
    showMesh(data.match_mesh, data.match_camera);
        
    words = {['VoxelIOU: ' num2str(data.voxelIOU, '%.3f  ')];
        ['Surface Distance: ' num2str(data.surfaceDist, '%.3f  ')]};
    
    axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box', ...
        'off','Visible','off','Units','normalized', 'clipping' , 'off');


    text(.5, .2,words,'HorizontalAlignment', ...
        'center','VerticalAlignment', 'top', 'FontSize', 30);
        

    if(nargin > 1)
        saveas(h, out);
    end
end

function showMesh(mesh, camera)
    if(nargin > 1)
       [M,P,V] = getCamera(struct('camera',camera));
       [~,~,mesh] = ApplyCamera(mesh, M,P,V);
    end
    patch('Faces', mesh.f', 'Vertices', mesh.v(1:3,:)', 'FaceColor', [.5,.5,.5], ...
            'EdgeColor', 'none', 'facelighting', 'phong');
    axis equal;
    axis off;
    light('Position', [-4, -4, 8]);
    light('Position', [4, 4, 8]);
    light('Position', [0,-4,0]);
    %{
    set(gca,'LooseInset',get(gca,'TightInset'))
    set( gca, 'Units', 'normalized', 'Position', [0 0 1 1] );
    %}
end

