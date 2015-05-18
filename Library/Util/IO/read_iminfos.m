function [iminfo] = read_iminfos(directories)
for i = 1:numel(directories)
  iminfo_new = CreateImInfo(directories{i}, true);
  if i > 1
    iminfo = struct_concat(iminfo, iminfo_new)
  else
    iminfo = iminfo_new;
  end
end
iminfo = parse_iminfo(iminfo);
end

