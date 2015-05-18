function [matches] = parse_matches(matches)
root = cell(length(matches.testImages),1);
objName = cell(length(matches.testImages),1);
meshNumber = cell(length(matches.testImages),1);
viewNumber = cell(length(matches.testImages),1);

parfor i = 1:length(matches.testImages)
    [root{i}, objName{i}, meshNumber{i}, viewNumber{i}] = parsePath(matches.testImages{i});
end

matches.testImageRoot = root;
matches.testImageObjName = objName;
matches.testImageMeshNumber = meshNumber;
matches.testImageViewNumber = viewNumber;

root = cell(length(matches.trainImages),1);
objName = cell(length(matches.trainImages),1);
meshNumber = cell(length(matches.trainImages),1);
viewNumber = cell(length(matches.trainImages),1);

parfor i = 1:length(matches.trainImages)
    [root{i}, objName{i}, meshNumber{i}, viewNumber{i}] = parsePath(matches.trainImages{i});
end

matches.trainImageRoot = root;
matches.trainImageObjName = objName;
matches.trainImageMeshNumber = meshNumber;
matches.trainImageViewNumber = viewNumber;

end
