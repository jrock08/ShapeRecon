function locMax = slidingWindowMax(voxel, varargin)
args=inputParser;
addOptional(args, 'windowSize', 3, @isnumeric);
parse(args, varargin{:});
args = args.Results;
%%

% dilation mask
s = args.windowSize;
msk = true(s, s, s);
sc = round(mean([1 s]));
msk(sc, sc, sc) = false;

% local maximum
locMax = imdilate(voxel,msk)==voxel & voxel>0;
