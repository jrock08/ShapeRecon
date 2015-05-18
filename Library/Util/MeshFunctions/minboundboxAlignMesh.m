function [ Mesh ] = minboundboxAlignMesh( Mesh )

[rotmat] = minboundbox(Mesh.v(1,:),Mesh.v(2,:),Mesh.v(3,:));

Mesh.v = rotmat'*Mesh.v;
if(isfield(Mesh,'I'))
    Mesh.I = (rotmat'*Mesh.I')';
end
if(isfield(Mesh,'v_sample'))
    Mesh.v_sample = [];
end

end

