function [index] = getImInfoIndex(iminfo, obj_name, mesh_number, view_number)
selection = strcmp(iminfo.objName, obj_name) & strcmp(iminfo.meshNumber, mesh_number) & strcmp(iminfo.viewNumber, view_number);
assert(sum(selection) > 0);

if(sum(selection) ~= 1)
    warning(['Duplicate Mesh-camera: ' obj_name '-' mesh_number '-' view_number]);
end

index = find(selection, 1);
