function [w, ll, bestB] = trainLogisticRegressionL2(data, labels, valfraction, Bset, xw)
% 
% Trains linear logistic regression with L1 regularization in the form
% w* = argmax_w sum_i log(y_i | data_i) subject to sum_j |w_j| <= B 
% where P(y=1|data) = 1 ./ (1+exp(-w*[data ; 1]))
% B is chosen from Bset using validation set with fraction set by
% valfraction.  
%
% Input:
%  data(ndata, nvar)
%  labels(ndata, 1) in {0,1} or {-1, 1}
%  valfraction in (0..1) or list of indices for validation set
%  Bset (e.g., [1 2 4 8 16 ...])


data = [data ones([size(data, 1) 1])];

labels = double(labels);
labels(labels==0) = -1;

[ndata, nvar] = size(data);

if numel(valfraction)>1
    test = valfraction;
else
    ind = randperm(ndata);
    test = ind(1:floor(valfraction*ndata));
end
train = setdiff((1:ndata), test);

if numel(train)>5000
  ind = randperm(numel(train));
  train = train(ind(1:5000));
end

% choose B using validation set
initw = 0.1*randn([nvar 1]);
%initw = initw /sum(abs(initw)) * Bset(1) /2;

bestw = initw;
bestB = -1;
bestll = Inf;
for B = Bset
    %initw = 0.1*randn([nvar 1]);
    %initw = initw / sum(abs(B));
%     [w, ll] = fminunc(@(x)loglikelihood(x, data(train, :), labels(train), B), initw);    
    
    if ~exist('xw', 'var') || isempty(xw)
      [w, ll] = fminunc(@(x)loglikelihood(x, data(train, :), labels(train), B), initw, ... 
         optimset('GradObj', 'on', 'Display', 'off'));
    else
    [w, ll] = fmincon(@(x)loglikelihoodw(x, data(train, :), labels(train), xw(train)), ...
      initw, [], [], [], [], [], [], @(t)regularizationConstraint(t, B), ... 
       optimset('GradObj', 'on', 'Display', 'off'));
    end
    %disp(num2str([B ll]))
    
    tmpll = 1./(1+exp(-labels(test).*(data(test, :)*w)));
    testll = -mean(log(tmpll));
    %testll = loglikelihood(w, data(test, :), labels(test), 0);
    if exist('xw', 'var') && ~isempty(xw)
       testll = loglikelihoodw(w, data(test, :), labels(test), xw(test));
    end
    disp(num2str([B sum(abs(w)) testll ...
        mean(tmpll>0.5) mean(tmpll(labels(test)==-1)>0.5) mean(tmpll(labels(test)==1)>0.5)]))
    if testll < bestll
        bestll = testll;
        bestB = B;
        bestw = w;
    else
      disp('breaking early since out of local minima')
      break;
    end
    
    initw = w;

end

% train over entire data
% initw = 0.1*randn([nvar 1]);
% initw = initw / sum(abs(bestB));
initw = bestw;

if ~exist('xw', 'var') || isempty(xw)
  [w, ll] = fminunc(@(x)loglikelihood(x, data, labels, bestB), initw, ...
        optimset('GradObj', 'on', 'MaxFunEvals', 200*size(data, 2), 'MaxIter', ...
        200*size(data, 2)));
else
  [w, ll] = fmincon(@(x)loglikelihoodw(x, data, labels, xw), initw, [], [], ...
        [], [], [], [], @(t)regularizationConstraint(t, bestB), ...
        optimset('GradObj', 'on', 'MaxFunEvals', 200*size(data, 2), 'MaxIter', ...
        200*size(data, 2)));
end
disp(num2str([bestB ll]))


%% negative log likelihood of data with gradient
function [ll, gll] = loglikelihood(w, x, y, B)
% w(nvar, 1)
% x(ndata, nvar)
% y(ndata, 1) = -1 or 1

likelihood = 1./(1+exp(-y.*(x*w)));

ll = sum(log(likelihood));
ll = -ll / numel(y) + B*sum(w.^2);
%disp(num2str(ll))

% gradient
if nargout>1
    gll = -x'*(y./(1+exp(y.*(x*w))))/numel(y) + 2*B*w;
end


%% negative log likelihood of data with gradient
function [ll, gll] = loglikelihoodw(w, x, y, xw)
% w(nvar, 1)
% x(ndata, nvar)
% y(ndata, 1) = -1 or 1
% xw(ndata, 1): weights

% if exist('B', 'var')
%     w = w / sum(abs(w)) * B;
% end

likelihood = 1./(1+exp(-y.*(x*w)));

ll = sum(xw.*log(likelihood));
ll = -ll / sum(xw);
%disp(num2str(ll))

% gradient
if nargout>1
    gll = -x'*((xw.*y)./(1+exp(y.*(x*w))))/sum(xw);    
end


%% enforce sum_i |w_i| <= B
function [c, ceq, gc, gceq] = regularizationConstraint(w, B)
c = sum(abs(w))-B;
ceq = 0;
if nargout>2
    gc = sign(w);
    gceq = 0;
end
