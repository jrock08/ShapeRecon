function classes = getClassesFromDir(root)
    d = dir(root);
    classes = {};
    for i = 1:length(d)
       if(d(i).name(1) == '.' ||~d(i).isdir) 
           continue;
       end
       classes{end+1} = d(i).name;
    end
end