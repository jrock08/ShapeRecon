function splitClasses(in_dir, out_dirA, nClassesA, out_dirB, nClassesB, idx)
    classes = getClassesFromDir(in_dir);
    
    if(length(idx) < nClassesA + nClassesB)
       idx = randperm(length(classes)); 
    end
    
    classesA = classes(idx(1:nClassesA));
    classesB = classes(idx(nClassesA+1:nClassesA+nClassesB));
    
    % copy classes
    if(~exist(out_dirA, 'dir'))
        mkdir(out_dirA);
    end
    for i = 1:length(classesA)
        d = dir([in_dir '/' char(classesA{i}) '/D*']);
        for j = 1:length(d)
            if(~exist([out_dirA '/' char(classesA{i})], 'dir'))
                mkdir([out_dirA '/' char(classesA{i})]);
            end
            fclose(fopen([out_dirA '/' char(classesA{i}) '/' char(d(j).name)], 'w'));
        end
    end
    
    if(~exist(out_dirB, 'dir'))
        mkdir(out_dirB);
    end
    for i = 1:length(classesB)
        d = dir([in_dir '/' char(classesB{i}) '/D*']);
        for j = 1:length(d)
            if(~exist([out_dirB '/' char(classesB{i})], 'dir'))
                mkdir([out_dirB '/' char(classesB{i})]);
            end
            fclose(fopen([out_dirB '/' char(classesB{i}) '/' char(d(j).name)], 'w'));
        end
    end
end
