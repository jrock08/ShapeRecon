function [mesh, varargout] = poissonSurfaceFromVoxel(voxel, varargin)
% Output: [mesh, surfPoints, normals]
%   mesh: mesh reconstructed using poisson reconstruction
%   surfPoints: estimated voxel surface points
%   normals: normals for the corresponding surface points.
%            length indicates weight.
%
p=inputParser;
addOptional(p, 'showFigure', false);
addOptional(p, 'depth', 7);
addOptional(p, 'includeRawSurface', true);
addOptional(p, 'method', 1);
addOptional(p, 'saveFigure', false);
parse(p, varargin{:});
args = p.Results;
%%

showFigure = args.showFigure;

if args.method == 1
    voxelSurf = detectVoxelSurface(voxel);
    surfpts_corners = imregionalmax(voxelSurf, 6);

    locmax = slidingWindowMax(voxelSurf, 'windowSize', 7);
    surfpts_flat_large = locmax & ~surfpts_corners;

    locmax = slidingWindowMax(voxelSurf, 'windowSize', 2);
    surfpts_flat = locmax & ~surfpts_corners & ~surfpts_flat_large;

    if showFigure
        figure('Position', [100, 100, 1000, 1000]);
        setfig; hold on;
        title('surface sample points');
        displayVoxelPointCloud(surfpts_flat, 'marker', '.', 'color', [0 0 1]);
        displayVoxelPointCloud(surfpts_flat_large, 'marker', '.', 'color', [1 0 0]);
        displayVoxelPointCloud(surfpts_corners, 'marker', '+', 'color', [0 1 0]);
        
        if args.saveFigure
        saveTightFigure(sprintf('%d-1.png', args.method));
        savefig(sprintf('%d-1', args.method));
        end

        figure('Position', [100, 100, 1000, 1000]);
        setfig; hold on;
        title('regional max point normals');

    end


    % "corner" points
    [points1, pointNormals1] = computeVoxelNormals(surfpts_corners, voxel, ...
        'windowSize', 1, 'showFigure', showFigure, 'multiplier', 0.85, ...
        'isWeighted', false);

    % local maxima in flatter regions
    [points2, pointNormals2] = computeVoxelNormals(surfpts_flat, voxel, ...
        'windowSize', 1, 'showFigure', false, 'multiplier', 0.03, ...
        'isWeighted', false);

    % local maxima in flatter, larger regions
    [points3, pointNormals3] = computeVoxelNormals(surfpts_flat_large, voxel, ...
        'windowSize', 1, 'showFigure', false, 'multiplier', 0.12, ...
        'isWeighted', false);

    % every point near the surface. give this more weight if there aren't enough points
    if args.includeRawSurface
        [points4, pointNormals4] = computeVoxelNormals(voxelSurf, voxel, ...
            'windowSize', 1, 'showFigure', false, 'multiplier', 0.002, ...
            'isWeighted', true);
    else
        points4 = []; pointNormals4 = [];
    end

    needsMorePoints = (size(points2, 1)/10.0+size(points3, 1)+1)/size(points4, 1) < 0.02;
    if needsMorePoints
        pointNormals4 = pointNormals4 * 7;
    end

    points = [points1; points2; points3; points4];
    pointNormals = [pointNormals1; pointNormals2; pointNormals3; pointNormals4];

    if showFigure
        if args.saveFigure
        saveTightFigure(sprintf('%d-2.png', args.method));
        savefig(sprintf('%d-2', args.method));
        end
    end
    
elseif args.method == 2
    
    voxelSurf = detectVoxelSurface(voxel);
    locmax = slidingWindowMax(voxelSurf, 'windowSize', 2);

    [points, pointNormals] = computeVoxelNormals(locmax, voxel, ...
            'windowSize', 1, 'showFigure', false, 'multiplier', 1, ...
            'isWeighted', false);
  
    if showFigure
        figure('Position', [100, 100, 1000, 1000]);
        setfig; hold on;
        title('surface sample points.  2');
        displayVoxelPointCloud(locmax, 'marker', '.', 'color', [0 0 1]);

        if args.saveFigure
        saveTightFigure(sprintf('%d.png', args.method));
        savefig(sprintf('%d', args.method));
        end
    end
    
elseif args.method == 3
    
    voxelSurf = detectVoxelSurface(voxel);
    [points, pointNormals] = computeVoxelNormals(voxelSurf, voxel, ...
            'windowSize', 1, 'showFigure', false, 'multiplier', 1, ...
            'isWeighted', true);

    if showFigure
        figure('Position', [100, 100, 1000, 1000]);
        setfig; hold on;
        title('surface sample points.  3');
        displayVoxelPointCloud(voxelSurf, 'marker', '.', 'color', [0 0 1]);

        if args.saveFigure
        saveTightFigure(sprintf('%d.png', args.method));
        savefig(sprintf('%d', args.method));
        end
    end
    
elseif args.method == 4
    
    voxelSurf = detectVoxelSurface(voxel);
    surfpts_corners = imregionalmax(voxelSurf, 6);
    [points, pointNormals] = computeVoxelNormals(surfpts_corners, voxel, ...
            'windowSize', 1, 'showFigure', false, 'multiplier', 1, ...
            'isWeighted', false);
    
    if showFigure
        figure('Position', [100, 100, 1000, 1000]);
        setfig; hold on;
        title('surface sample points.  4');
        displayVoxelPointCloud(surfpts_corners, 'marker', '.', 'color', [0 0 1]);

        if args.saveFigure
        saveTightFigure(sprintf('%d.png', args.method));
        savefig(sprintf('%d', args.method));
        end
    end

end


% Usage: poissonRecon(points, normals, depth, fullDepth, scale, samplesPerNode, cgDepth):
% fullDepth = 5; scale = 1.1; samplesPerNode = 1; cgDepth = 0;
%[mesh.f, mesh.v] = poissonRecon(points, pointNormals, args.depth);

fullDepth = 5;
scale = 1.1;
samplesPerNode = 1;
cgDepth = 0;

[mesh.f, mesh.v] = poissonRecon(points, pointNormals, args.depth, fullDepth, ...
    scale, samplesPerNode, cgDepth, 0);

if nargout > 1, varargout{1} = points;, end
if nargout > 2, varargout{2} = pointNormals;, end

if showFigure
    figure, setfig; hold on;
    displayMesh(mesh);
    title('reconstructed mesh');
end
