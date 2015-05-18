function [ camera ] = readCamera( fileId )
tline = fgets_n(fileId);
if(~strcmp(tline,'PerspectiveCamera {'))
    error(['Did not read a camera, read: ' tline]);
end

position_line = fgets_n(fileId);
interest_line = fgets_n(fileId);
up_line       = fgets_n(fileId);
angle_line    = fgets_n(fileId);
l_line        = fgets_n(fileId);
camera.string = [tline char(10)...
    position_line char(10)...
    interest_line char(10)...
    up_line char(10)...
    angle_line char(10)...
    l_line];

%Reading the Camera Position
a = regexp(position_line,'\s+','split');
% ['' 'camera_position' '#', '#', '#']
if(~strcmp(a(2),'camera_position'))
    error(['error in camera position reading expected: camera_position got: ' a(2)]);
end
camera.position = [str2double(a(3)),str2double(a(4)),str2double(a(5))];

%Reading the point of interest
a = regexp(interest_line,'\s+','split');
if(~strcmp(a(2),'point_of_interest'))
    error(['error in camera position reading expected: point_of_interest got: ' a(2)]);
end
camera.point_of_interest = [str2double(a(3)),str2double(a(4)),str2double(a(5))];

%Reading the up vector
a = regexp(up_line,'\s+','split');
if(~strcmp(a(2),'up'))
    error(['error in camera position reading expected: up got: ' a(2)]);
end
camera.up = [str2double(a(3)),str2double(a(4)),str2double(a(5))];

%Reading Angle (viewing angle)
a = regexp(angle_line,'\s+','split');
if(~strcmp(a(2),'angle'))
    error(['error in camera position reading expected: angle got: ' a(2)]);
end
camera.angle = str2double(a(3));

%this reads the blank line printed after camera
%fgets(fileId)

end

function [tline] = fgets_n(fileId)
tline = fgets(fileId);
tline(end) = [];
end
