function [ squareImage ] = cutImage( image )
%CUTIMAGE Crop the image into square foreground image

BACKGROUD = 255;

% Calculate max and min foreground row and column
isForeground = image ~= BACKGROUD;
colSum = sum(isForeground);
foregroundColIdx = find(colSum);
maxCol = max(foregroundColIdx);
minCol = min(foregroundColIdx);
rowSum = sum(isForeground, 2);
foregroundRowIdx = find(rowSum);
maxRow = max(foregroundRowIdx);
minRow = min(foregroundRowIdx);

% Cut the original image and prepare the square image to fill the data
width = maxCol - minCol + 1;
height = maxRow - minRow + 1;
squareSize = max([width, height]);
cutImage = image(minRow:maxRow, minCol:maxCol);
squareImage = uint16(ones(squareSize) .* BACKGROUD);

% Center-align the foreground image into the cut square
padCol = floor((squareSize - width) / 2) + 1;
padRow = floor((squareSize - height) / 2) + 1;
squareImage(padRow:(padRow + height - 1), padCol:(padCol + width - 1)) = cutImage;

end

