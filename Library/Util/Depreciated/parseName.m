function [object_name, mesh_number, view_number] = parseName(file_path_name)
% Parses a Mesh filepath that looks like the following
% path/to/../ObjectClass/D00452.off_v2_depth.png
% To ['ObjectClass', 'D00452', 'v2']
warning('Depreciated, use parsePath instead')

[~, object_name_, mesh_number_, view_number_] = parsePath(file_path_name);

file_path_name = strrep(file_path_name, '\', filesep);

[pathstring, name, ~] = fileparts(file_path_name);

Q = strsplit(pathstring, filesep);
object_name = Q{end};

if(name(1) == 'D')
[~, mesh_number, view_] = fileparts(name);
view_split = strsplit(view_, '_');
view_number = view_split{2};
return;
end

if(any(strfind(name, 'sphere')==0) | any(strfind(name, 'box')==0) | any(strfind(name, 'cylinder')==0))
[~, mesh_number, view_] = fileparts(name);
view_split = strsplit(view_, '_');
view_number = view_split{2};
return;
end

name_split = strsplit(name, '_');
view_number = name_split{4};

name = [name_split{1} '_' namesplit{2} '_' namsplit{3}];

%% Verify depreciation.
assert(object_name == object_name_);
assert(mesh_number == mesh_number_);
assert(view_number == view_number_);

end
