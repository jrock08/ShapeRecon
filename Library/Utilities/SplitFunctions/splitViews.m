function splitViews(in_dir, out_dirA, nViewsA, out_dirB, nViewsB, idx)
    views = getViewsFromDir(in_dir);
    
    if(length(idx) < nViewsA + nViewsB)
       idx = randperm(length(views)); 
    end
    
    viewsA = views(idx(1:nViewsA));
    viewsB = views(idx(nViewsA+1:nViewsA+nViewsB));
    
    if(~exist(out_dirA, 'dir'))
        mkdir(out_dirA);
    end
    
    d = dir([in_dir '/*_out.off']);
    for i = 1:length(d)
       fclose(fopen([out_dirA '/' char(d(i).name)], 'w')); 
    end
    d = dir([in_dir '/*.txt']);
    for i = 1:length(d)
       fclose(fopen([out_dirA '/' char(d(i).name)], 'w'));
    end
    for i = 1:length(viewsA)
        d = dir([in_dir '/*' char(viewsA{i}) '*']);
        for j = 1:length(d)
            fclose(fopen([out_dirA '/' char(d(j).name)], 'w'));
        end
    end

    if(~exist(out_dirB, 'dir'))
        mkdir(out_dirB);
    end
    
    d = dir([in_dir '/*_out.off']);
    for i = 1:length(d)
        fclose(fopen([out_dirB '/' char(d(i).name)], 'w'));
    end
    d = dir([in_dir '/*.txt']);
    for i = 1:length(d)
       fclose(fopen([out_dirB '/' char(d(i).name)], 'w'));
    end
    for i = 1:length(viewsB)
        d = dir([in_dir '/*' char(viewsB{i}) '*']);
        for j = 1:length(d)
            fclose(fopen([out_dirB '/' char(d(j).name)], 'w'));
        end
    end
end

