function result = restrictMatch(testImgIdx)

FEAT_SIZE = 10;
result = cell(size(testImgIdx, 1), 1);
for i=1:size(testImgIdx, 1)
    allMatches = [testImgIdx{i, :}];
    [n, b] = histc(allMatches, unique(allMatches));
    dup = [];
    dupI = find(n>1);
    for j = dupI
        is = find(b==j);
        dup = [dup, allMatches(is(1))];
    end
    randpool = [];
    bigpool = [];
    for j = 1:size(testImgIdx, 2)
        if length([testImgIdx{i, j}]) <= 5
            randpool = [randpool, testImgIdx{i, j}];
        else
            bigpool = [bigpool, testImgIdx{i, j}];
        end
    end
    for j=1:length(dup)
        randpool(randpool==dup(j)) = [];
        bigpool(bigpool==dup(j)) = [];
    end
    fin = [];
    if length(randpool) + length(dup) >= FEAT_SIZE
        if length(dup) >= FEAT_SIZE
            fin = randsample(dup, FEAT_SIZE);
        else
            fin = dup;
            fin = [fin, randsample(randpool, FEAT_SIZE - length(dup))];
        end
    else
        fin = [dup, randpool];
        ssize = FEAT_SIZE - length(dup) - length(randpool);
        if length(bigpool) >= ssize
            fin = [fin, randsample(bigpool, ssize)];
        else
            fin = [fin, bigpool];
        end
    end
    result{i} = fin;
end

end