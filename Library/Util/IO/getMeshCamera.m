function [camera, mesh, selection] = getMeshCamera(iminfo, obj_name, mesh_number, view_number)
%warning('Favor queryIminfo over getMeshCamera');
selection = getImInfoIndex(iminfo, obj_name, mesh_number, view_number);
camera = iminfo.camera{selection};
if(nargout >= 2)
  mesh = readMesh(iminfo.meshes{selection});
end
end

