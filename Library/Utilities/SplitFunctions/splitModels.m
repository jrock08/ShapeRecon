function splitModels(in_dir, out_dirA, nModelsA, out_dirB, nModelsB, idx)
    models = getModelsFromDir(in_dir);
    
    if(length(idx) < nModelsA + nModelsB)
       idx = randperm(length(models)); 
    end
    
    modelsA = models(idx(1:nModelsA));
    modelsB = models(idx(nModelsA+1:nModelsA+nModelsB));
    
    % copy models
    if(~exist(out_dirA, 'dir'))
        mkdir(out_dirA);
    end
    for i = 1:length(modelsA)
        d = dir([in_dir '/' char(modelsA{i}) '*']);
        for j = 1:length(d)
            fclose(fopen([out_dirA '/' char(d(j).name)], 'w'));
        end
    end

    if(~exist(out_dirB, 'dir'))
        mkdir(out_dirB);
    end
    for i = 1:length(modelsB)
        d = dir([in_dir '/' char(modelsB{i}) '*']);
        for j = 1:length(d)
            fclose(fopen([out_dirB '/' char(d(j).name)], 'w'));
        end
    end
end

