function createAnimation(mesh,angleRes,filename,tmpName)
filename
f = figure('visible','off');
currentDir = pwd;
displayMesh2(mesh);
% view(2);
camorbit(gca,-360/angleRes,0);
% mkdir(fullfile(tmpName))
cd(tmpName)
for i=1:angleRes
    i
    camorbit(gca,360/angleRes,0);
    saveTightFigure(f,['theta_' num2str(i) ],'-dpng','-r300');
end
% for i=1:angleRes
%     camorbit(gca,0,360/angleRes);
%     saveTightFigure(f,['phi_' num2str(i)],'-dpng','-r300');
% end
cd(currentDir)
outputVideo = VideoWriter(filename);
outputVideo.FrameRate = 10;
open(outputVideo)
for i=1:angleRes
    x=imread([tmpName '/theta_' num2str(mod(i-1,angleRes)+1) '.png']);
     writeVideo(outputVideo,imresize(x,.25));
end
% for i=1:angleRes
%     x=imread([tmpName '/phi_' num2str(mod(i-1,angleRes)+1) '.png']);
%      writeVideo(outputVideo,imresize(x,.25));
% end
close(outputVideo);
close(f);
% rmdir(tmpName,'s');


     
    

    
    
   
    