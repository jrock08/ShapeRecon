function model = weakTrain(X, Y, entropyFeature, opts)
% weak random learner

minImg = 2;
[N, D]= size(X);

if nargin < 3, entropyFeature=zeros(0); end
if nargin < 4, opts = struct; end
if isfield(opts, 'minImg'), minImg = opts.minImg; end

if N <= 1
    % edge case. No data reached this leaf. Don't do anything...
    return;
end

if isempty(entropyFeature)
    u= unique(Y);
else
    u = unique(entropyFeature(:));
end

model = struct;
if ~isempty(entropyFeature)
    H = classDecisionEntropy(entropyFeature, u);
end

maxgain= eps*10;

% proceed to pick optimal splitting value t, based on Information Gain  
for r = 1:size(X, 2)
    col= X(:, r);
    t = 0.5;
    dec = col < t;
    if sum(dec) >= minImg && sum(~dec) >= minImg
        if isempty(entropyFeature)
            Igain = evalDecision(Y, dec, u);
        else
            Igain = evalDecisionEntropy(entropyFeature, dec, H, u);
        end

        if Igain>maxgain
            maxgain = Igain;
            model.r= r;
            model.t= t;
        end
    end
end

end

function Igain = evalDecisionEntropy(entropyFeature, dec, H, u)
    entropyFeatureL= entropyFeature(dec, :);
    entropyFeatureR= entropyFeature(~dec, :);
    HL= classDecisionEntropy(entropyFeatureL, u);
    HR= classDecisionEntropy(entropyFeatureR, u);
    Igain= H - size(entropyFeatureL, 1)/size(entropyFeature, 1)*HL ...
        - size(entropyFeatureR, 1)/size(entropyFeature, 1)*HR;
end

function H= classDecisionEntropy(entropyFeature, u)
    cdist= histc(entropyFeature, u);
    cdist= cdist./repmat(sum(cdist), length(u), 1);
    cdist= cdist .* log(cdist);
    cdist(isnan(cdist)) = 0;
    H= -sum(cdist(:));
end

function Igain= evalDecision(Y, dec, u)
% gives Information Gain provided a boolean decision array for what goes
% left or right. u is unique vector of class labels at this node

    YL= Y(dec);
    YR= Y(~dec);
    H= classEntropy(Y, u);
    HL= classEntropy(YL, u);
    HR= classEntropy(YR, u);
    Igain= H - length(YL)/length(Y)*HL - length(YR)/length(Y)*HR;

end

% Helper function for class entropy used with Decision Stump
function H= classEntropy(y, u)

    cdist= histc(y, u);
    cdist= cdist/sum(cdist);
    cdist= cdist .* log(cdist);
    cdist(isnan(cdist)) = 0;
    H= -sum(cdist);
    
end
