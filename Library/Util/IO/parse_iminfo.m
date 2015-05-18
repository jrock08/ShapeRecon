function [iminfo] = parse_iminfo(iminfo)
parfor i = 1:length(iminfo.images)
    [root{i}, objName{i}, meshNumber{i}, viewNumber{i}] = parsePath(iminfo.images{i});
end

iminfo.root = root;
iminfo.objName = objName;
iminfo.meshNumber = meshNumber;
iminfo.viewNumber = viewNumber;
end

