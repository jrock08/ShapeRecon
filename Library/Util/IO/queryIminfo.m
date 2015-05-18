function [iminfo_struct] = queryIminfo(iminfo, obj_name, mesh_number, view_number)
selection = getImInfoIndex(iminfo, obj_name, mesh_number, view_number);

iminfo_struct.camera = iminfo.camera{selection};
iminfo_struct.mesh = readMesh(iminfo.meshes{selection});

iminfo_struct.mesh_simp = readMesh(iminfo.meshes_simp{selection});
iminfo_struct.depth = imread(iminfo.images{selection});

if(isfield(iminfo, 'masks') && exist(iminfo.masks{selection},'file'))
  iminfo_struct.mask = imread(iminfo.masks{selection});
else
  iminfo_struct.mask = iminfo_struct.depth < 255;
end

