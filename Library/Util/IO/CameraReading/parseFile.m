function parseFile( filename, outputdir )

fid = fopen(filename);


i = 0;
while ~feof(fid)
    camera = readCamera(fid);
    
    edges = {};
    while ~feof(fid)
        tline = fgets_n(fid);
        unread(fid,tline);
        if(iscamera(tline))
            break
        end
        edges{end+1} = readEdge(fid);
    end
    save([outputdir '/v_' int2str(i) '_edges.mat'],'edges','camera'); 
    i = i+1;

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
