function displayVoxel( voxel, threshold )
%DISPLAYVOXEL Display a vectorized cube voxel

if nargin < 2
    threshold = 0.01;
end
vsize = nthroot(length(voxel), 3);
[x,y,z] = ind2sub([vsize, vsize, vsize], find(voxel > threshold));
scatter3(x,y,z,10,'r','filled');

end

