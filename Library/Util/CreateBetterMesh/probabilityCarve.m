function [ voxel_carve, voxel_distance, voxel_angle ] = probabilityCarve( pcl )
%This scaling is unsafe
pcl_scaled = (pcl+2)*200/4;

depthmap = createFakeDepthIm(pcl_scaled);

exterior = bwdist(isnan(depthmap));
contour_selection = exterior < 2 & exterior > 0;


[X,Y] = meshgrid(1:200, 1:200);

contour_x = X(contour_selection);
contour_y = Y(contour_selection);

[~,I] = pdist2([contour_x, contour_y, depthmap(contour_selection)], [X(:),Y(:),depthmap(:)],'euclidean','smallest',1);

contour_idx = I;

contour_depthmap = NaN(size(depthmap));
contour_depthmap(contour_selection) = depthmap(contour_selection);
% [~,contour_idx] = bwdist(~isnan(contour_depthmap));

contour_depthmap_ = NaN(size(depthmap));
contour_idx_x = NaN(size(depthmap));
contour_idx_y = NaN(size(depthmap));
for i = find(~isnan(depthmap))'%1:numel(contour_idx)
    [sub_x, sub_y] = ind2sub([200,200],i);
%     contour_x(contour_idx(i)), contour_y(contour_idx(i))
    contour_idx_x(sub_x, sub_y) = contour_x(contour_idx(i));
    contour_idx_y(sub_x, sub_y) = contour_y(contour_idx(i));
    contour_depthmap_(sub_x, sub_y) = contour_depthmap(contour_y(contour_idx(i)), contour_x(contour_idx(i)));
end
contour_depthmap_(isnan(depthmap)) = NaN;

[vx, vy, vz] = meshgrid(1:200,1:200,1:200);

dval_stack = repmat(depthmap,[1,1,200]);

dval_stack(isnan(dval_stack)) = 0;

% Construct return values.  Carve is 1 for voxels behind the depthmap.
voxel_carve = dval_stack > vz;
% How far behind the depthmap is a voxel.
voxel_distance = voxel_carve.*exp((-((vz-dval_stack)/10).^2));

% Is the voxel a candidate for accidentally occlusion? eg table leg.
voxel_angle = zeros(200, 200, 200);

contour_idx_x_stack = repmat(contour_idx_x, [1,1,200]);
contour_idx_y_stack = repmat(contour_idx_y, [1,1,200]);
contour_depthmap_stack = repmat(contour_depthmap_, [1,1,200]);

x = sqrt(double(vx-contour_idx_x_stack).^2 + (vy - contour_idx_y_stack).^2 + (dval_stack-contour_depthmap_stack).^2);
y = abs(dval_stack - vz);
z = sqrt(double(vx-contour_idx_x_stack).^2 + (vy - contour_idx_y_stack).^2 + (vz-contour_depthmap_stack).^2);
voxel_angle = 1 - (y.^2+z.^2-x.^2)./(2.*y.*z);

voxel_angle(isnan(voxel_angle)) = 0;

end

