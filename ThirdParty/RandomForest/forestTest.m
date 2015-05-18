function [result] = forestTest(model, X, opts)
    
    if nargin<3, opts= struct; end
    
    numTrees= length(model.treeModels);
    result = cell(length(X), numTrees);
    for i=1:numTrees
        result(:, i) = treeTest(model.treeModels{i}, X, opts);
    end
end
