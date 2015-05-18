function views = getViewsFromDir(in_dir)
    d = dir([in_dir '/*depth.png']);
    views = {};
    for i = 1:length(d)
        tokens = strsplit(d(i).name, '_', 'DelimiterType','RegularExpression');
        if(length(tokens) ~= 3) 
            continue;
        end
        views{end+1} = tokens(2);
    end
end