function check_iminfo2(OutputDir, path_to_data_dir, data_type, forceCreateFlag, type)
% Input:
% OutpuDir - Output directory where the iminfo will be saved
% path_to_data_dir - A cell array of the directories that need to be 
% save in iminfo
% data_type - Should be one of {'Validation','ValidationSubset','Test','TestSubset'}
% forceCreateFlag - Set to true if want to create iminfo again even if a
% file with the same name exists

if(nargin < 5)
  type = 'segmented';
end

path_to_iminfo = [OutputDir 'iminfo_' data_type '.mat'];
if(exist(path_to_iminfo,'file')~=2 || forceCreateFlag)

    if(strcmp(type, 'segmented'))
      eval(['iminfo_' data_type '=' 'read_iminfos(path_to_data_dir)']);
        N = size(path_to_data_dir,2);
        eval(['iminfo_' data_type '=' 'cell(N,1)']);
        for i=1:N
            eval(['iminfo_' data_type '{i,1}' '=' 'read_iminfos({path_to_data_dir{1,i}})']);
        end
    elseif(strcmp(type, 'combined'))
        eval(['iminfo_' data_type '=' 'read_iminfos(path_to_data_dir)']);
    end

    eval(['save(''' path_to_iminfo ''', ''iminfo_' data_type ''')']);
end
