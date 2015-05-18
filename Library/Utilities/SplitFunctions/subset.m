function subset(root, classes, models, views, classes2, models2, views2, out)

fprintf('Loading file choices: ');
files = {};
files2 = {};
d = dir(root);
for i = 1:length(d)
   if(d(i).name(1) == '.')
       continue;
   end
   d2 = dir([root '/' char(d(i).name) '/*depth.png']);
   for j = 1:length(d2)
       files{end+1} = [root '/' char(d(i).name) '/' char(d2(j).name)];
   end
end
fprintf('%d\n', length(files));

class_offset = models*views;
model_offset = views;
view_offset = 1;
selected_classes = randperm(classes, classes2);

fprintf('Selecting random files: ');
for i = 1:length(selected_classes)
   selected_models = randperm(models, models2);
   for j = 1:length(selected_models)
      selected_views = randperm(views, views2);
      selected_files = (selected_classes(i) - 1) * class_offset +  ...
          (selected_models(j) - 1) * model_offset + selected_views;
      files2 = [files2, files(selected_files)];
   end
end
fprintf('%d\n', length(files2));


fprintf('Copying files\n');
for i = 1:length(files2)
    tokens = strsplit(char(files2{i}), '[/,\\]', 'DelimiterType','RegularExpression');
    class = char(tokens(end-1));
    file = char(tokens(end));
    if(~exist([out '/' char(class)], 'dir'))
       mkdir([out '/' char(class)]); 
    end
    copyfile(char(files2{i}), [out '/' char(class) '/' char(file)]);
end


end

