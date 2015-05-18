function [ voxel, mesh ] = CreateMeshFromMatch(pcl_queryRot, pcl_symRef, ...
                                               mesh_defRot, Neighbor, ...
                                               voxel_classifier, depth_Dist)
% Note - load classifier and check dimension of voxel_features
if(nargin < 4)
    Neighbor = 10*voxel6connected(200,200,200);
end

[voxel_distance, voxel_sym, voxel_angle, voxel_defRot, voxel_similarity, not_exist_voxel, ~] = CreateMeshFromMatch2(pcl_queryRot, pcl_symRef, mesh_defRot);

def_exist = voxel_distance > exp(-(4/100));

if(~isempty(pcl_symRef))
    [voxel_sym] = probabilityCarve_symmetry(pcl_symRef);
else
    voxel_sym = zeros(200,200,200);
end

similarity_score = similarityFeature(pcl_queryRot,mesh_defRot);
voxel_similarity1 = similarity_score*ones(200,200,200);
voxel_similarity2 = depth_Dist*ones(200,200,200);

%% To be considered..boosted decision tree based log likelihood
%% ratio prediction
voxel_distance_vec = vectorize(voxel_distance);
voxel_sym_vec = vectorize(voxel_sym);
voxel_angle_vec = vectorize(voxel_angle);
voxel_defRot_vec = vectorize(voxel_defRot);
voxel_similarity1_vec = vectorize(voxel_similarity1);
voxel_similarity2_vec = vectorize(voxel_similarity2);

voxel_features = [voxel_distance_vec, voxel_sym_vec, voxel_angle_vec, ...
                  voxel_defRot_vec, voxel_similarity1_vec, ...
                  voxel_similarity2_vec];

LLRatio = voxel_classifier(voxel_features);
logLikelihoodRatio = inv_vectorize(LLRatio(:,1),size(voxel_distance));

% p1 = 1/(1+exp(-(1.7697*voxel_distance+0.4489*voxel_sym+2.8747*voxel_angle+ 1.8273*voxel_defRot-2.2611+1.7)));
p2 = 1/(1+exp(-(1.9253*voxel_distance+3.6711*voxel_angle-1.8509+1.7)));


% Change this to false to create meshes directly from the voxels
is_poisson = false;

if is_poisson
    voxel{1} = solve_internal(logLikelihoodRatio, not_exist_voxel, def_exist, Neighbor);
    voxel{2} = solve_internal(log(p2./(1-p2)), not_exist_voxel, def_exist, Neighbor);

    depth = 8;
    for i = 1:numel(voxel)
        [mesh{i}] = poissonSurfaceFromVoxel(voxel{i}, ...
            'depth', depth, 'showFigure', false, 'includeRawSurface', true);
        mesh{i}.v = mesh{i}.v';
        mesh{i}.f = mesh{i}.f';
        mesh{i}.v([1 2],:) = mesh{i}.v([2 1],:);
        mesh{i}.v = (mesh{i}.v*4/200)-2;
    end
else
    [voxel{1}, mesh{1}] = solve_internal(logLikelihoodRatio, not_exist_voxel, def_exist, Neighbor);
    [voxel{2}, mesh{2}] = solve_internal(log(p2./(1-p2)), not_exist_voxel, def_exist, Neighbor);
end

end


function var_vec = vectorize(anyvar)
var_vec = reshape(anyvar,[prod(size(anyvar)) 1]);
end


function anyvar = inv_vectorize(var_vec,dim)
anyvar = reshape(var_vec,dim);
end


function [voxel, varargout] = solve_internal(voxel_tot, not_exist_voxel, def_exist_voxel, Neighbor)

I_n = not_exist_voxel;
v_n = 5 * ones(size(not_exist_voxel));

voxel_tot = voxel_tot + 5*def_exist_voxel;

I_p = find(voxel_tot);
v_p = voxel_tot(I_p);

A = sparse([I_n;I_p],[ones(size(I_n));2*ones(size(I_p))],[v_n; v_p],200^3,2);


[~,labels] = maxflow(Neighbor, A);

voxel = reshape(labels, [200,200,200]);

if nargout > 1
    [ X,Y,Z,c] = voxelToIso( voxel==1 );
    [F,V] = MarchingCubes(X,Y,Z,c,0);
    if(numel(F)/3 > 10000)
    m = reducepatch(struct('faces', F, 'vertices', V), 10000/(numel(F)/3));
    mesh.f = m.faces';
    mesh.v = m.vertices';
    else
    mesh.f = F';
    mesh.v = V';
    end

    mesh.v = (mesh.v*4/200)-2;

    varargout{1} = mesh;
end

end
