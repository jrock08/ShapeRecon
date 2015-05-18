function files = getFilesFromDir(in_dir)
files = {};
unique_classes = getClassesFromDir(in_dir);
for i = 1:length(unique_classes)
    d = dir([in_dir '/' char(unique_classes{i})]);
    for j = 1:length(d)
        if(d(j).name(1) == '.')
           continue; 
        end
        files{end+1} = [in_dir '/' char(unique_classes{i}) '/' char(d(j).name)];
    end
end
end

