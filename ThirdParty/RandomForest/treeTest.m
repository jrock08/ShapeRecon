function [result] = treeTest(model, X, opts)
    
if nargin < 3, opts= struct; end
result = treeTestInternal(model, X, opts);

end

function [result] = treeTestInternal(model, X, opts)
    
    result = cell(length(X), 1);
    if length(X) < 1, return; end
    Xf = extractFeature(X, model.fixedCoords, model.matchCoords);
    
    yhat = logical(weakTest(model.weakModel, Xf, opts));
    if ~isempty(model.left) && ~isempty(model.left.weakModel)
        result(yhat) = treeTestInternal(model.left, X(yhat), opts);
    else
        result(yhat) = repmat({model.leftY}, sum(yhat), 1);
    end
    
    nyhat = logical(1 - yhat);
    if ~isempty(model.right) && ~isempty(model.right.weakModel)
        result(nyhat) = treeTestInternal(model.right, X(nyhat), opts);
    else
        result(nyhat) = repmat({model.rightY}, sum(nyhat), 1);
    end
end