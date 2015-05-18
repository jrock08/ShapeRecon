function callbackUndoLastPoint( src, event )

global Points;
global pointHandles;

if(event.Character == 'u')
    if(~isempty(pointHandles))
        delete(pointHandles);
    end
    if(size(Points,1) >= 1)
        % highlight the newly selected point
        pointHandles = plot3(Points(end,1), Points(end,2), ...
            Points(end,3), 'b.', ...
            Points(1:end-1,1),Points(1:end-1,2), ...
            Points(1:end-1,3), 'm.', 'MarkerSize', 30);
        Points(end,:) = [];
    else
        pointHandles = [];
    end
end

if event.Character == 's'
    uiresume()
end

