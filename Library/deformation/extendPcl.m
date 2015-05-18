function pcl_complete = extendPcl(pcl_valid,mesh)
% Input -
% pcl_valid - 3 x #numPts1 matrix of valid pcl point coordinates
% mesh - struct of mesh.f and mesh.f which nearly fits pcl_valid
% Output -
% pcl_complete - 3 x #numPts2 matrix of complete point cloud that
% approximates pcl_valid


%% front-face culling
z = [0;0;1];
selectedFaces = zeros(size(mesh.f,2),1);
for i=1:size(mesh.f,2)
    v1 = mesh.v(:,mesh.f(1,i));
    v2 = mesh.v(:,mesh.f(2,i));
    v3 = mesh.v(:,mesh.f(3,i));
    n = cross(v2-v1,v3-v1)/(norm(v2-v1,2)*norm(v3-v1,2) + 0.001);
    theta = acosd(n'*z);
    if(theta > 88)
        selectedFaces(i,1)  = 1;
    end
end

%% retained faces after culling
idxFace = find(selectedFaces==1);
facesRetained = mesh.f(:,idxFace);

%% Generate points on the surface of the mesh
[meshPts, chosenFaceIdx] = genSurfPts(mesh.v,facesRetained,10000);

%% Get rid of points that have pcl_valid points in their neighborhood
kdtree = KDTreeSearcher(pcl_valid','Distance','euclidean','BucketSize',50);
[idx d] = knnsearch(kdtree,meshPts');

idxFar = find(d > 0.1);
pcl_complete = meshPts(:,idxFar);

