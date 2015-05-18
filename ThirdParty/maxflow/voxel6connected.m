function [ M ] = voxel6connected( height, width, length )

E = [];% zeros(height*width*length,2);

dx = [-1,1,0,0,0,0];
dy = [0,0,-1,1,0,0];
dz = [0,0,0,0,-1,1];
count = 1;

[I,J,K] = meshgrid(1:height, 1:width, 1:length);

IJK_ind = sub2ind([height, width, length], I, J, K);
for c = 1:numel(dx)
I_ = I+dx(c);
J_ = J+dy(c);
K_ = K+dz(c);

select = ~(I_<=0 | I_>height | J_<=0 | J_>width | K_<=0 | K_>length);
E = [E;[sub2ind([height, width, length], I_(select), J_(select), K_(select)), IJK_ind(select)]];
end


% for i = 1:height
%     for j = 1:width
%         for k = 1:length
%             for c = 1:numel(dx)
%                 ii = i+dx(c);
%                 jj = j+dy(c);
%                 kk = k+dz(c);
%                 
%                 if(ii <= 0 || ii>height || jj <= 0 || jj>width || kk<=0 || kk>=length)
%                     continue
%                 end
%                 E(count,1) = sub2ind([height, width, length], i,j,k);
%                 E(count,2) = sub2ind([height,width,length],ii,jj,kk);
%                 count = count +1;
%             end
%         end
%     end
% end
% E = E(1:count-1,:);

M = sparse(E(:,1),E(:,2),1,height*width*length, height*width*length);
end

