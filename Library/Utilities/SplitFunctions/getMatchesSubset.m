function ret = getMatchesSubset(train_dir, validation_dir, test_dir, matches, matchesSubset)

fprintf('Loading testing image data.\n');
for i = 1:length(matches.testImages)
    tokens = strsplit(matches.testImages{i}, '[\\,/]', 'DelimiterType','RegularExpression');
    matches.testImages{i} = char([test_dir '/' char(tokens(end-1)) '/' char(tokens(end))]);
    if(~exist(matches.testImages{i}, 'file'))
        warning(['Image file: ' matches.testImages{i} ' does not exist.\n']); 
    end
end
for i = 1:length(matchesSubset.testImages)
    tokens = strsplit(matchesSubset.testImages{i}, '[\\,/]', 'DelimiterType','RegularExpression');
    matchesSubset.testImages{i} = char([test_dir '/' char(tokens(end-1)) '/' char(tokens(end))]);
    if(~exist(matchesSubset.testImages{i}, 'file'))
        warning(['Image file: ' matchesSubset.testImages{i} ' does not exist.\n']); 
    end
end

fprintf('Loading training image data.\n');
for i = 1:length(matches.trainImages)
    tokens = strsplit(matches.trainImages{i}, '[\\,/]', 'DelimiterType','RegularExpression');
    matches.trainImages{i} = char([train_dir '/' char(tokens(end-1)) '/' char(tokens(end))]);
    if(~exist(matches.trainImages{i}, 'file'))
        matches.trainImages{i} = char([validation_dir '/' char(tokens(end-1)) '/' char(tokens(end))]);
    end
    if(~exist(matches.trainImages{i}, 'file'))
        warning(['Image file: ' matches.trainImages{i} ' does not exist.\n']); 
    end
end
for i = 1:length(matchesSubset.trainImages)
    tokens = strsplit(matchesSubset.trainImages{i}, '[\\,/]', 'DelimiterType','RegularExpression');
    matchesSubset.trainImages{i} = char([train_dir '/' char(tokens(end-1)) '/' char(tokens(end))]);
    if(~exist(matchesSubset.trainImages{i}, 'file'))
        matchesSubset.trainImages{i} = char([validation_dir '/' char(tokens(end-1)) '/' char(tokens(end))]);
    end
    if(~exist(matchesSubset.trainImages{i}, 'file'))
        warning(['Image file: ' matchesSubset.trainImages{i} ' does not exist.\n']); 
    end
end

fprintf('Selecting subset.\n');
idx = 0;
for i = 1:length(matchesSubset.testImgIdx)
    idx = idx | strcmp(matches.testImages, matchesSubset.testImages{i});
end

ret.testImages = matches.testImages(idx);
ret.trainImages = matches.trainImages;
ret.testImgIdx = matches.testImgIdx(idx);

if(sum(strcmp(ret.testImages, matchesSubset.testImages)) ~= length(ret.testImages))
   warning('Subset test images not matching.\n'); 
end

end