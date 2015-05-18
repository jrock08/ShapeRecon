function model = treeTrain(X, Y, entropyFeature, opts)

    if nargin < 3, entropyFeature=zeros(0); end
    if nargin < 4, opts= struct; end

    model = treeTrainInternal(X, Y, entropyFeature, opts);
end

function model = treeTrainInternal(X, Y, entropyFeature, opts)
    maxImgs = 5;
    verbose = 1;
    numFixedCoordsFeat = 500;
    numMatchCoordsFeat = 500;
    if isfield(opts, 'maxImgs'), maxImgs= opts.maxImgs; end
    if isfield(opts, 'verbose'), verbose= opts.verbose; end
    if isfield(opts, 'numFixedCoordsFeat'), numFixedCoordsFeat= opts.numFixedCoordsFeat; end
    if isfield(opts, 'numMatchCoordsFeat'), numMatchCoordsFeat= opts.numMatchCoordsFeat; end

    if verbose
        if length(Y) > 100
            fprintf('Training node of size %d\n', length(Y));
        end
    end
    
    % Extract random features
    model.fixedCoords = rand(2, numFixedCoordsFeat);
    model.matchCoords = rand(4, numMatchCoordsFeat);
    Xf = extractFeature(X, model.fixedCoords, model.matchCoords);
    
    % Discretize entropy features
    voxelFeatures = ones(size(entropyFeature));
    nonzeroEntropyFeature = entropyFeature(entropyFeature~=0);
    voxelFeatures(entropyFeature < prctile(nonzeroEntropyFeature(:), 33)) = 0;
    voxelFeatures(entropyFeature > prctile(nonzeroEntropyFeature(:), 66)) = 2;
    
    % Train weak learner
    opts.minImg = max(2, floor(length(Y)/10));
    model.weakModel = weakTrain(Xf, Y, voxelFeatures, opts);
    
    % If failed to train, return
    if ~isfield(model.weakModel, 'r')
        model.weakModel = [];
        return;
    end
    
    % Classify based on the obtained weak learner
    yhat = logical(weakTest(model.weakModel, Xf, opts));
    nyhat = logical(1 - yhat);
    clear Xf;
    
    % Recursively train tree
    if sum(yhat) > maxImgs
        relEntropyFeature = [];
        if ~isempty(entropyFeature)
            relEntropyFeature = entropyFeature(yhat, :);
        end
        model.left = treeTrainInternal(X(yhat), Y(yhat), relEntropyFeature, opts);
        if isempty(model.left.weakModel)
            model.leftY = Y(yhat);
        end
    else
        model.left = [];
        model.leftY = Y(yhat);
    end
    
    if sum(nyhat) > maxImgs
        relEntropyFeature = [];
        if ~isempty(entropyFeature)
            relEntropyFeature = entropyFeature(nyhat, :);
        end
        model.right = treeTrainInternal(X(nyhat), Y(nyhat), relEntropyFeature, opts);
        if isempty(model.right.weakModel)
            model.rightY = Y(nyhat);
        end
    else
        model.right = [];
        model.rightY = Y(nyhat);
    end
end