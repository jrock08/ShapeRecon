function [Table_Mean, Table_Median, raw] =  genStats(metrics)

Exp = {'NC';'NM';'NV'};
surfDist = cell(3,1);
surfDistDef = cell(3,1);
surfDistRecNoSym = cell(3,1);
surfDistRecSym = cell(3,1);
voxelIOU = cell(3,1);
voxelIOUDef = cell(3,1);
voxelIOURecNoSym = cell(3,1);
voxelIOURecSym = cell(3,1);

raw = [];

for i=1:3
    surfDist{i,1} =  mean(metrics{i}.surfaceDist);
    surfDistDef{i,1} =  mean(metrics{i}.surfaceDistDeformed);
    surfDistRecNoSym{i,1} =  mean(metrics{i}.surfaceDistReconstructedNoSym);
    surfDistRecSym{i,1} =    mean(metrics{i}.surfaceDistReconstructedSym);
    voxelIOU{i,1} =  mean(metrics{i}.voxelIOU);
    voxelIOUDef{i,1} =  mean(metrics{i}.voxelIOUDeformed);
    voxelIOURecNoSym{i,1} =  mean(metrics{i}.voxelIOUReconstructedNoSym);
    voxelIOURecSym{i,1} =    mean(metrics{i}.voxelIOUReconstructedSym);

    raw = [raw, surfDist{i,1}, surfDistDef{i,1}, surfDistRecNoSym{i,1},...
        surfDistRecSym{i,1}, voxelIOU{i,1}, voxelIOUDef{i,1},...
        voxelIOUDef{i,1}, voxelIOURecNoSym{i,1}, voxelIOURecSym{i,1}];
end

Table_Mean = table(surfDist,surfDistDef,surfDistRecNoSym,surfDistRecSym, ...
                   voxelIOU,voxelIOUDef,voxelIOURecNoSym,voxelIOURecSym, ...
                   'RowNames',Exp)
for i=1:3
    surfDist{i,1} =  median(metrics{i}.surfaceDist);
    surfDistDef{i,1} =  median(metrics{i}.surfaceDistDeformed);
    surfDistRecNoSym{i,1} =  median(metrics{i}.surfaceDistReconstructedNoSym);
    surfDistRecSym{i,1} =    median(metrics{i}.surfaceDistReconstructedSym);
    voxelIOU{i,1} =  median(metrics{i}.voxelIOU);
    voxelIOUDef{i,1} =  median(metrics{i}.voxelIOUDeformed);
    voxelIOURecNoSym{i,1} =  median(metrics{i}.voxelIOUReconstructedNoSym);
    voxelIOURecSym{i,1} =    median(metrics{i}.voxelIOUReconstructedSym);
end

Table_Median = table(surfDist,surfDistDef,surfDistRecNoSym,surfDistRecSym, ...
                   voxelIOU,voxelIOUDef,voxelIOURecNoSym,voxelIOURecSym, ...
                   'RowNames',Exp)
