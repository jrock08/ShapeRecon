function [ edge ] = readEdge( fid )
% edge.name -- the name of the type of edge
% edge.line_3d nx2, index into the mesh vertices
% edge.line_2d nxmx2, m varies based on visiblility of an edge, but is
%                     always even and >=2
edge.name = fgets_n(fid);


edge.line_3d = [];
edge.line_2d = {};
edge.line_2d_index = {};

while(~feof(fid))
    line_3d = fgets_n(fid);
    if(feof(fid))
        unread(fid, line_3d)
        return;
    end
    line_2d = fgets_n(fid);
    [start,stop] = regexp(line_3d,'\d+ \d+');
    if(isempty(start) || start ~= 1 || isempty(stop) || stop ~= length(line_3d))
        unread(fid,line_2d);
        unread(fid,line_3d);
        return;
    end
    
    edge.line_3d(end+1,:) = str2double(regexp(line_3d,'\d+','match'));
    edge.line_2d{end+1} = str2double(reshape(regexp(line_2d,'[\s;]+','split'),2,[]))';
    edge.line_2d_index{end+1} = 0*edge.line_2d{end}(1,:)+size(edge.line_3d,1);
end 
    
    
end

function unread(fileId, line)
%Seek negative the size of last line (plus the newline) from (cof)
%current position
fseek(fileId,-length(line)-1,'cof');
end

function [tline] = fgets_n(fileId)
tline = fgets(fileId);
tline(end) = [];
end