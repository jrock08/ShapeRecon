function copyAll(root, src)

d = dir(root);
for i = 1:length(d)
   if(d(i).name(1) == '.')
       continue;
   end
   file = dir([root '/' char(d(i).name)]);
   for j = 1:length(file)
      if(file(j).name == '.')
          continue;
      end
      copyfile([src '/' char(d(i).name) '/' char(file(j).name)], ...
          [root '/' char(d(i).name) '/' char(file(j).name)]);
   end
end

end

