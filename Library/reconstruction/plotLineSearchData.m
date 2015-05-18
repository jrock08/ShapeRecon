setup_shape_reconstruction;

close all;

load([OutputDir 'Table_of_Means_SIMILARITY_BDT']);

N = size(Table_of_Means,1);
voxelIOU_BDT = zeros(N,1);
voxelIOU_LR = zeros(N,1);

BIAS = [0:N-1]*0.2;
for b=1:N 
    voxelIOU_BDT(b,1) = Table_of_Means{b,1}{1,end} + ...
        Table_of_Means{b,1}{2,end} + Table_of_Means{b,1}{3,end};
end
voxelIOU_BDT =voxelIOU_BDT/3;

load([OutputDir 'Table_of_Means_SIMILARITY_LR']);
for b=1:N 
    voxelIOU_LR(b,1) = Table_of_Means{b,1}{1,end} + ...
        Table_of_Means{b,1}{2,end} + Table_of_Means{b,1}{3,end};
end
voxelIOU_LR =voxelIOU_LR/3;
figure,plot(BIAS,voxelIOU_LR,'r-', ...
     BIAS,voxelIOU_BDT,'b-');
xlabel('bias');
ylabel('voxelIOU');
legend('LR','BDT');

%% surfDist
surfDist_BDT = zeros(N,1);
surfDist_LR = zeros(N,1);

load([OutputDir 'Table_of_Means_SIMILARITY_BDT']);
for b=1:N 
    surfDist_BDT(b,1) = Table_of_Means{b,1}{1,4} + ...
        Table_of_Means{b,1}{2,4} + Table_of_Means{b,1}{3,4};
end
surfDist_BDT =surfDist_BDT/3;

load([OutputDir 'Table_of_Means_SIMILARITY_LR']);
for b=1:N 
    surfDist_LR(b,1) = Table_of_Means{b,1}{1,4} + ...
        Table_of_Means{b,1}{2,4} + Table_of_Means{b,1}{3,4};
end
surfDist_LR =surfDist_LR/3;
figure,plot(BIAS,surfDist_LR,'r-', ...
     BIAS,surfDist_BDT,'b-');
xlabel('bias');
ylabel('surfDist');
legend('LR','BDT');