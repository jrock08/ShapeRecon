function [ Mesh ] = samplePointsInMesh( Mesh )
%SAMPLEPOINTSINMESH samples a bunch of points that exist on the mesh stores
%to Mesh.v_sample

if(isfield(Mesh,'v_sample') && ~isempty(Mesh.v_sample))
    return
    %Already has a v_sample
end

sample_multiplier = 300;

Mesh.v_sample = [];
Mesh.v_sample_from = [];

for i = 1:size(Mesh.f,2);
    v1 = Mesh.v(1:3,Mesh.f(1,i));
    v2 = Mesh.v(1:3,Mesh.f(2,i));
    v3 = Mesh.v(1:3,Mesh.f(3,i));
    Area = norm(cross(v2-v1,v3-v1))/2;
    
    A = rand(2,ceil(sample_multiplier*Area));
    A(1,:) = sqrt(A(1,:));
    X = (1-A(1,:));
    Y = A(1,:).*(1-A(2,:));
    Z = A(1,:).*A(2,:);
    Mesh.v_sample_from = [Mesh.v_sample_from, ones(size(Z)) *i];
    Mesh.v_sample = [Mesh.v_sample, v1*X+v2*Y+v3*Z];
end

end

