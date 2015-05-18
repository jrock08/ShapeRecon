function dispMatch( img1, img2, matches )
% JunYoung.  Displays the feature matches between the images.

% Resize images to 0.5 scale
img1 = imresize(img1, 0.5);
img2 = imresize(img2, 0.5);

% Assumption that height of the images are same
if size(img1, 1) ~= size(img2, 1)
    return
end
offset = size(img1, 2);

imshow([img1, img2]);
hold on;

% Draw lines between matches
x = zeros(2,1);
y = zeros(2,1);
for i=1:size(matches, 2)
    x(1) = matches(1, i);
    y(1) = matches(2, i);
    x(2) = matches(3, i) + offset;
    y(2) = matches(4, i);

    line(x, y);
    plot(x(1), y(1), 'r','MarkerSize',50);
    plot(x(2), y(2), 'r','MarkerSize',50);
end

end

