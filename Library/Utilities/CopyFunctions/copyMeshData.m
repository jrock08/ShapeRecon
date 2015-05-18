function copyMeshData(root, src)

d = dir(root);
for i = 1:length(d)
    if(d(i).name(1) == '.')
        continue;
    end
    class = char(d(i).name);
    file = dir([root '/' class '/*depth.png']);
    for j = 1:length(file)
        if(file(j).name == '.')
            continue;
        end
        tokens = strsplit(file(j).name,  '[_,.]', 'DelimiterType','RegularExpression');
        model = char(tokens(1));
      
        file_to_copy = [model '.off_out.txt'];
        if(~exist([root '/' class '/' file_to_copy]))
            copyfile([src '/' class '/' file_to_copy], ...
                [root '/' class '/' file_to_copy]);
        end
      
        file_to_copy = [model '.off'];
        if(~exist([root '/' class '/' file_to_copy]))
            copyfile([src '/' class '/' file_to_copy], ...
                [root '/' class '/' file_to_copy]);
        end

        file_to_copy = [model '_out.off'];
        if(~exist([root '/' class '/' file_to_copy]))
            copyfile([src '/' class '/' file_to_copy], ...
                [root '/' class '/' file_to_copy]);
        end 
    end
end

end

