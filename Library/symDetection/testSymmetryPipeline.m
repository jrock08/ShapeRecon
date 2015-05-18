% clear all
% close all
% clc

% matlabpool('open',4);
%% Read the vertices from the .off mesh file format files
% filepath = 'C:\Users\Tanmay Gupta\Dropbox\UIUC\RA\Shape and Material from Single Image\Dataset\';
% filepath=['C:\Users\Tanmay Gupta\Dropbox\UIUC\RA\Shape and Material from Single Image\Dataset\Mesh_Pairs\Fish_Fish'];
% filepath = 'C:\Users\Tanmay Gupta\Dropbox\UIUC\RA\Shape and Material from Single Image\Code\Proof of Concept\mesh_aligned3_two\Data\train\Car_aligned\D00236.off';
% [vertex, face] = read_mesh([filepath '\src_fish.off']);
% [vertex, face] = read_mesh(filepath);
FV.faces = mesh.f';
FV.vertices = mesh.v';

[clustCent,data2cluster,cluster2dataCell,symmetryPts1, symmetryPts2] = symmetryPipeline_0_3(FV);
[symPts1, symPts2, sortedClusterCent] = genSymPts(clustCent,cluster2dataCell,FV);
