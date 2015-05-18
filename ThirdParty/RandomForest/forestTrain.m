function model = forestTrain(images, entropyFeature, opts)
    
    numTrees= 100;
    verbose= true;
    
    if nargin < 2, entropyFeature=[]; end
    if nargin < 3, opts= struct; end
    if isfield(opts, 'numTrees'), numTrees= opts.numTrees; end
    if isfield(opts, 'verbose'), verbose= opts.verbose; end
    Y = 1:length(images);

    treeModels= cell(1, numTrees);
    
    parfor i=1:numTrees
        
        set(0,'RecursionLimit', 2000);
        
        treeModels{i} = treeTrain(images, Y, entropyFeature, opts);
        
        % print info if verbose
        if verbose
            fprintf('Trained tree %d/%d\n', i, numTrees);
        end
    end
    
    model.treeModels = treeModels;
end
