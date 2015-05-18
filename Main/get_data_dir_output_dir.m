function [data_dir, output_dir] = get_data_dir_output_dir(baseDir)

[~, host] = system('hostname');

% Remove trailing whitespace
host = deblank(host);
disp(host)

if(~isempty(strfind(host, 'jrock')))
  disp('Jason Desktop')
  data_dir = '/home/jrock/Data/Meshes/2015/';
  output_dir = [baseDir '/output/'];
  return;
end

if(~isempty(strfind(host, 'Bluebird')))
  disp('JunYoung Desktop')
  data_dir = 'D:\Downloads\Dataset\ShapeReconstruction';
  output_dir = [baseDir '/Main/DataFiles/'];
  return;
end

if(~isempty(strfind(host, 'crunchy')))
  disp('Tanmay Desktop')
  data_dir = '~/Data/Shape2014/Data2';
  output_dir = [baseDir '/Main/DataFiles/'];
  return;
end

if(~isempty(strfind(host, 'daeyun-desktop')))
  disp('Daeyun Desktop')
  data_dir = '~/Data/Shape2014/Data2/';
  %output_dir = [baseDir '/Main/DataFiles/'];
  output_dir = '/home/daeyun/hdd/Shape2014/DataOut/';
  return;
end

if(~isempty(strfind(host, 'vision')))
  %error(['vision nodes not setup yet']);
  disp('vision node')
  data_dir = '/shared/daf/cvpr15_shape/Data2_Jason';
  output_dir = [baseDir '/output/'];
  return;
end

if(~isempty(strfind(host, 'taub')) | ~isempty(strfind(host, 'golub')))
  error(['campus cluster not setup yet']);
  disp('campus cluster')
  data_dir = '/projects/VisionLanguage/jjrock2/Data';
  output_dir = '/projects/VisionLanguage/jjrock2/';
  return;
end

disp(['Unknown ' host ': Default locations assumed']);
data_dir = [baseDir '/Data'];
output_dir = [baseDir '/output/'];

end
