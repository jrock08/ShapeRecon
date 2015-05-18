function yhat = weakTest(model, X, ~)

yhat = double(X(:, model.r) < model.t);

end