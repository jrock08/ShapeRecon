function models = getModelsFromDir(root)
    d = dir([root '/*_out.off']);
    models = cell(1, length(d));
    for i = 1:length(d)
        models{i} = d(i).name(1:6);
    end
end