function create_selected_display(iminfo, metrics, reconstructions, matches, indices_only)

% for i = 1:3
%   mean_voxel_val = median(metrics{i}.voxelIOUReconstructedSym);
%   %mean_surf_val = mean(metrics{i}.surfaceDistReconstructedSym);
%   
%   %great_selection = find(metrics{i}.voxelIOU < .7*metrics{i}.voxelIOUDeformed);
% 
%   %great_selection = find(metrics{i}.voxelIOU < .7*metrics{i}.voxelIOUDeformed & metrics{i}.voxelIOUReconstructedSym > 1.2*mean_voxel_val);
%   % & metrics{i}.voxelIOUReconstructedNoSym < metrics{i}.voxelIOUReconstructedSym*.9 & metrics{i}.voxelIOUReconstructedSym > mean_voxel_val*1.5);
% 
%   %selection = find(metrics{i}.voxelIOUReconstructedNoSym < metrics{i}.voxelIOUReconstructedSym*.9);
%   
%   %[v,idx] = sort(metrics{i}.voxelIOUReconstructedSym);
%   %great_selection = idx(end-25:end);
%   
% %   great_selection = find(...
% %     metrics{i}.voxelIOUReconstructedSym > mean_voxel_val &...
% %     metrics{i}.surfaceDistReconstructedSym < mean_surf_val);
% %   if(numel(great_selection) > 25)
% %     sample_by = max(1,floor(numel(great_selection)/25));
% %     great_selection = great_selection(1:sample_by:end);
% %   end
% 
%  % good_selection = find(...
%  %   metrics{i}.voxelIOUReconstructedSym > mean_voxel_val - .03 & ...
%  %   metrics{i}.voxelIOUReconstructedSym > mean_voxel_val + .03);
%  % if(numel(good_selection) > 25)
%  %   sample_by = floor(numel(good_selection)/25)
%  %   good_selection = good_selection(1:sample_by:end);
%  % end
% 
%  % [v,idx] = sort(metrics{i}.voxelIOUReconstructedSym);
%  % bad_selection = idx(1:25);
%  % [v,idx] = sort(metrics{i}.surfaceDistReconstructedSym);
%  % bad_selection = unique([bad_selection, idx(1:25)]);
%  % if(numel(bad_selection) > 25)
%  %   sample_by = floor(numel(bad_selection)/25)
%  %   bad_selection = bad_selection(1:sample_by:end);
%  % end
%  % DisplayStupidBaseline(iminfo, reconstructions{i}, matches{i}, great_selection, ['_' num2str(i) '_greats']);
% 
%  %DisplayReconstruction(iminfo, reconstructions{i}, matches{i}, great_selection, ['_' num2str(i) '_greats']);
%  % DisplayReconstruction(iminfo{i}, reconstructions{i}, good_selection, ['_' num2str(i) '_mean']);
%  % DisplayReconstruction(iminfo{i}, reconstructions{i}, bad_selection, ['_' num2str(i) '_bad']);
% 
% end

for i=1:3
    selection = indices_only{i};
    DisplayReconstruction(iminfo, reconstructions{i}, matches{i}, metrics{i}, selection, ['recon_' num2str(i)]);
end


% i = 1;
% selection = [18,22,53,100,326,360,419,427,480,536];
% DisplayReconstruction(iminfo, reconstructions{i}, matches{i}, selection, ['_' num2str(i) '_greats']);
% 
% i = 2;
% selection = [593];
% DisplayReconstruction(iminfo, reconstructions{i}, matches{i}, selection, ['_' num2str(i) '_greats']);

% i = 3;
% selection = [81,92,101,387,426,444,493,594];
% DisplayReconstruction(iminfo, reconstructions{i}, matches{i}, selection, ['_' num2str(i) '_greats']);
end
