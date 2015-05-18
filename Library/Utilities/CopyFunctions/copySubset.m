function copySubset(in, data_dir, out)

class = dir(in);
for i = 1:length(class)
    if(class(i).name(1) == '.')
        continue;
    end
    if(~exist([out '/' class(i).name], 'dir'))
        mkdir([out '/' class(i).name]);
    end
    model = dir([in '/' class(i).name '/*_out.off']);
    for j = 1:length(model)
        tokens = strsplit(model(j).name, '_', 'DelimiterType','RegularExpression');
        name = char(tokens(1));
        copyfile([data_dir '/' class(i).name '/' name '*depth.png'], [out '/' class(i).name '/'])
        copyfile([data_dir '/' class(i).name '/' name '*.txt'], [out '/' class(i).name '/'])
        copyfile([data_dir '/' class(i).name '/' name '*.off'], [out '/' class(i).name '/'])
    end
end