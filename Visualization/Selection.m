function [ indices_only ] = Selection( metrics )

for i = 1:3
    [~,idx] = sort(metrics{i}.voxelIOUReconstructedSym);
    indices_only{i} = [idx(end-25:end)];
    %indices_only{i} = [idx(1:25), idx(end-25:end)];
    %indices_only{i,1} = idx(1:25);
    %indices_only{i,2} = idx(end-25:end);
    
    med = median(metrics{i}.voxelIOUReconstructedSym);
    [~,idx] = sort(abs(metrics{i}.voxelIOUReconstructedSym-med));
    %indices_only{i,3} = idx(1:25);
    %indices_only{i} = [indices_only{i}, idx(1:25)];
end

end

