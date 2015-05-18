function [ F, xidx, yidx ] = MeshFromDepthMap( depthmap_mask, depthmap )
% Computes the triangles that need to be included for this mask.
% Connects pixels to their neighbors.

[xidx,yidx] = find(depthmap_mask);

vertex_idx = 1:numel(xidx);

QQ = zeros(size(depthmap_mask));
QQ(depthmap_mask) = vertex_idx;

ind_idx = sub2ind(size(depthmap_mask), xidx, yidx);
Q = NaN(numel(depthmap_mask),1);
Q(ind_idx) = vertex_idx;

dx = [1,-1];
dy = [0,0];

dx2 = [0,0];
dy2 = [1,-1];


F = [];

for i = 1:2
    xdelt1 = xidx+dx(i);
    ydelt1 = yidx+dy(i);
    try
        xyind1 = sub2ind(size(depthmap_mask), xdelt1, ydelt1);
    catch
        continue;
    end

    xdelt2 = xidx+dx2(i);
    ydelt2 = yidx+dy2(i);
    try
        xyind2 = sub2ind(size(depthmap_mask), xdelt2, ydelt2);
    catch
        continue
    end

    sel_1 = false(size(xyind1));
    sel = depthmap_mask(xyind1) & depthmap_mask(xyind2);

    gradient = abs(double(depthmap(ind_idx)) - (double(depthmap(xyind1)) + double(depthmap(xyind2)))/2);

    sel = sel & gradient < 10;

    selected = find(sel);
    sel_1(selected(170)) = true;
    %sel = sel_1;
    F = [F, [Q(xyind1(sel))'; Q(ind_idx(sel))'; Q(xyind2(sel))']];
end

%% Add the symmetric side
% F = [F, F+numel(xidx)];
% 
% 
% sym_vertex_index = numel(xidx)+1:2*numel(xidx);
% 
% exterior = (depthmap_mask) & (imdilate(~depthmap_mask, strel('disk', 1)));
% exterior2 = imfilter(exterior, [1,1,1;1,1,1;1,1,1]);
% 
% 
% CC = bwconncomp(exterior,8);
% 
% for i = 1:CC.NumObjects
%     specific_im = false(size(depthmap_mask));
%     specific_im(CC.PixelIdxList{1}) = true;
%     
%     [x,y] = find(specific_im);
%     ind_idx = find(specific_im);
%     
%     specific_im = double(specific_im);
%     
%     ind_seen = [];
%     
%     xprev = -1;
%     yprev = -1;
%     indprev = -1;
%     xon = x(1);
%     yon = y(1);
%     ind_on = ind_idx(1);
%     while numel(ind_seen) < numel(ind_idx)
%         dx = [-1,1,0,0,-1,-1,1,1];
%         dy = [0,0,-1,1,-1,1,-1,1];
%         
%         for i = 1:numel(dx)
%             sel = x==xon+dx(i) & y==yon+dy(i) & ~(xprev == xon+dx(i) & yprev == yon+dy(i));
%             if(any(sel))
%                 xon
%                 yon
%                 xon+dx(i)
%                 yon+dx(i)
%                 ind_next = ind_idx(sel);
%                 x_next = xon+dx(i);
%                 y_next = yon+dy(i);
%                 
%                 F = [F, [Q(ind_on); Q(ind_next); Q(ind_on)+numel(xidx)]];
%                 if(indprev > 0)
%                     F = [F, [Q(ind_on); Q(ind_on)+numel(xidx); Q(indprev)+numel(xidx)]];
%                 end
%                 break;
%             end
%         end
%         
%         specific_im(xon,yon) = .1;
% 
%         xprev = xon;
%         yprev = yon;
%         indprev = ind_on;
%         ind_seen = [ind_seen, ind_on];
%         
%         specific_im(x_next, y_next) = .5;
% 
%         
%         xon = x_next;
%         yon = y_next;
%         ind_on = ind_next;
%     end
% end   

end

