function displayAlignment(root, count, file)
close all;
meshes = dir([root '/D*_out.off']);

idx = randperm(length(meshes), count);

for i = 1:count
    h = figure;
    a = readMesh([root '/' meshes(idx(i)).name]);
    patch('Faces', a.f', 'Vertices', a.v', 'FaceColor', [.5,.5,.5], ...
        'EdgeColor', 'none', 'facelighting', 'phong');
    axis equal;
    axis off;
    light('Position', [-4, -4, 8]);
    light('Position', [4, 4, 8]);
    light('Position', [0,-4,0]);
    view(3);
    set(gca,'LooseInset',get(gca,'TightInset'))
    set( gca, 'Units', 'normalized', 'Position', [0 0 1 1] );
    saveas(h, [file '_' num2str(i) '.png']);
end

images{i} = cell(1, count);
x1 = 50000;
y1 = 50000;
x2 = 0;
y2 = 0;
for i = 1:count
    images{i} = rgb2gray(imread([file '_' num2str(i) '.png']));
    [r,c] = find(images{i} < 255);

    %{
    x1 = min([x1; c]);
    y1 = min([y1; r]);
    x2 = max([x2; c]);
    y2 = max([y2; r]);
    %}
   
   
    x1 = min(c);
    y1 = min(r);
    x2 = max(c);
    y2 = max(r);
    width = x2-x1;
    height = y2-y1;
   
    images{i} = imcrop(images{i}, [x1,y1,width,height]);
    imwrite(images{i}, [file '_' num2str(i) '.png']);
end
%{
width = x2 - x1;
height = y2 - y1;

for i = 1:count
   images{i} = imcrop(images{i}, [x1,y1,width,height]);
   imwrite(images{i}, [file '_' num2str(i) '.png']);
end
%}

end



