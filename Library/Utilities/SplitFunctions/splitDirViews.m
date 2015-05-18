function splitDirViews(in_dir, out_dirA, nViewsA, out_dirB, nViewsB, idx)
classes = getClassesFromDir(in_dir);
for i = 1:length(classes)
    splitViews([in_dir '/' char(classes{i})], ...
        [out_dirA '/' char(classes{i})], nViewsA, ...
        [out_dirB '/' char(classes{i}) ], nViewsB, idx); 
end
end

