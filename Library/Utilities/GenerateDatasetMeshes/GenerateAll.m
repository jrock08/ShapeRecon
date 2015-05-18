mesh = {};
for i = .2:.2:1
    for j = .2:.2:1
        for k = .2:.2:1
            if(i==j && j==k && i~=1)
                continue;
            end
            mesh{end+1} = GenerateCylinder(i,j,k);
            writeMesh(mesh{end},['basic_shapes/cylinder/cylinder' num2str(i/2*10) '' num2str(j/2*10) num2str(k/2*10) '.off']);
            mesh{end+1} = GenerateSphere(i,j,k);
            writeMesh(mesh{end},['basic_shapes/sphere/sphere' num2str(i/2*10) '' num2str(j/2*10) num2str(k/2*10) '.off']);
            mesh{end+1} = GenerateBox(i,j,k);
            writeMesh(mesh{end},['basic_shapes/box/box' num2str(i/2*10) '' num2str(j/2*10) '' num2str(k/2*10) '.off']);
        end
    end
end
