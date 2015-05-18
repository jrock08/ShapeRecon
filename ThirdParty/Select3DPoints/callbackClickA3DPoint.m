function callbackClickA3DPoint(src, eventData, pointCloud)
% CALLBACKCLICK3DPOINT mouse click callback function for CLICKA3DPOINT
%
%   The transformation between the viewing frame and the point cloud frame
%   is calculated using the camera viewing direction and the 'up' vector.
%   Then, the point cloud is transformed into the viewing frame. Finally,
%   the z coordinate in this frame is ignored and the x and y coordinates
%   of all the points are compared with the mouse click location and the 
%   closest point is selected.
%
%   Babak Taati - May 4, 2005
%   revised Oct 31, 2007
%   revised Jun 3, 2008
%   revised May 19, 2009

point = get(gca, 'CurrentPoint'); % mouse click position
camPos = get(gca, 'CameraPosition'); % camera position
camTgt = get(gca, 'CameraTarget'); % where the camera is pointing to

camDir = camPos - camTgt; % camera direction
camUpVect = get(gca, 'CameraUpVector'); % camera 'up' vector

% build an orthonormal frame based on the viewing direction and the 
% up vector (the "view frame")
zAxis = camDir/norm(camDir);    
upAxis = camUpVect/norm(camUpVect); 
xAxis = cross(upAxis, zAxis);
yAxis = cross(zAxis, xAxis);

rot = [xAxis; yAxis; zAxis]; % view rotation 

% the point cloud represented in the view frame
rotatedPointCloud = rot * pointCloud; 

% the clicked point represented in the view frame
rotatedPointFront = rot * point' ;

% find the nearest neighbour to the clicked point 
pointCloudIndex = dsearchn(rotatedPointCloud(1:2,:)', ... 
    rotatedPointFront(1:2));

global pointHandles;
global Points;
selectedPoint = pointCloud(:, pointCloudIndex); 

if isempty(pointHandles) % if it's the first click (i.e. no previous point to delete)
    
    % highlight the selected point
    pointHandles = plot3(selectedPoint(1,:), selectedPoint(2,:), ...
        selectedPoint(3,:), 'r.', 'MarkerSize', 30);

else % if it is not the first click
    delete(pointHandles);
    Points
    % highlight the newly selected point
    pointHandles = plot3(selectedPoint(1,:), selectedPoint(2,:), ...
        selectedPoint(3,:), 'r.', ...
            Points(:,1),Points(:,2), Points(:,3), ...
            'm.','MarkerSize', 30); 
    uistack(pointHandles);
end

Points(end+1,:) = selectedPoint;
fprintf('you clicked on point number %d\n', pointCloudIndex);
