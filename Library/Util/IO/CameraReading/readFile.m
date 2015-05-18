function [ file_value ] = readFile( filename )

fid = fopen(filename);


file_value = {};

%for i = 1:10
%i = 1;
while ~feof(fid) %&& i < 10
    %i = i+1;
    file_value{end+1}.camera = readCamera(fid);
    
    file_value{end}.edges = {};
    while ~feof(fid)
        tline = fgets_n(fid);
        unread(fid,tline);
        if(iscamera(tline))
            break
        end
        file_value{end}.edges{end+1} = readEdge(fid);
    end
end

fclose(fid);

end

function outp = iscamera(line)
outp = strcmp(line,'PerspectiveCamera {');
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
