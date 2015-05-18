function [ depth_im_fake ] = createFakeDepthIm(pcl_rescale)
X = round(pcl_rescale(2,:));
Y = round(pcl_rescale(1,:));
D = pcl_rescale(3,:);

depth_im_fake = NaN(200,200);

for i = 1:length(X)
    if(X(i)>0 && X(i)<200 && Y(i)>0 && Y(i)<200)
        depth_im_fake(X(i),Y(i)) = D(i);
    end
end

end

