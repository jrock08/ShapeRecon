function copyViews(root, src, dst)
class = dir(root);
count = 0;
totalTime = 0;
for i = 1:length(class)
    if(class(i).name(1) == '.')
        continue;
    end
    tic;
    fprintf('Class %d / %d\n', i, length(class));
    % check for class directory
    if(~exist([dst '/' char(class(i).name)], 'dir'))
        mkdir([dst '/' char(class(i).name)]);
    end
    
    % check for views
    file = dir([root '/' char(class(i).name) '/*depth.png']);
    for j = 1:length(file)
        tokens = strsplit(file(j).name, '[_]', 'DelimiterType','RegularExpression');
        model = tokens(1);
        view = tokens(2);
        copyfile([src '/' char(class(i).name) '/' char(model) '_' char(view) '*.png'], ...
            [dst '/' char(class(i).name)]);
    end
    
    % check for models
    file = dir([root '/' char(class(i).name) '/*.txt']);
    for j = 1:length(file)
        tokens = strsplit(file(j).name, '[.]', 'DelimiterType','RegularExpression');
        model = tokens(1);
        copyfile([src '/' char(class(i).name) '/' char(model) '.off'], ...
            [dst '/' char(class(i).name) '/' char(model) '.off']);
        copyfile([src '/' char(class(i).name) '/' char(model) '_out.off'], ...
            [dst '/' char(class(i).name) '/' char(model) '_out.off']);
        copyfile([src '/' char(class(i).name) '/' char(model) '.off_out.txt'], ...
            [dst '/' char(class(i).name) '/' char(model) '.off_out.txt']);
    end
    time = toc;
    totalTime = totalTime + time;
    count = count+1;
    avgTime = totalTime / count;
    seconds = avgTime * (length(class) - i);
    minutes = seconds / 60;
    hours = floor(minutes / 60);
    seconds = floor(seconds - (floor(minutes)*60));
    minutes = floor(minutes - hours*60);
    fprintf('Estimated remaining time: %.2d:%.2d:%.2d\n', hours, minutes, seconds);
end

end

