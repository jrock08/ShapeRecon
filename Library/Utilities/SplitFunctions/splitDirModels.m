function splitDirModels(in_dir, out_dirA, nModelsA, out_dirB, nModelsB, idx)
classes = getClassesFromDir(in_dir);
for i = 1:length(classes)
    splitModels([in_dir '/' char(classes{i})], ...
        [out_dirA '/' char(classes{i})], nModelsA, ...
        [out_dirB '/' char(classes{i}) ], nModelsB, idx); 
end
end

