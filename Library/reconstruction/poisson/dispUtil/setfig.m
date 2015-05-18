function setfig(v)

hold on;
axis equal;
grid on;

if nargin < 2
    v = [1 1 1];
end

% axis([-1 1 -1 1 -1 1]);
set(gcf, 'renderer', 'opengl');
% set(gca, 'CameraPosition', [1000 4000 -6000]);
% set(gca, 'CameraPosition', [1000 4000 -6000]);
view(v);

cameratoolbar('Show');
cameratoolbar('SetMode', 'orbit');
cameratoolbar('SetCoordSys', 'z');

xlabel('x');
ylabel('y');
zlabel('z');

set(gcf,'KeyPressFcn', @clickCallback);

function clickCallback(fig_obj, ~)
    if get(fig_obj, 'CurrentCharacter')==' '
        campos
[az,el] = view
    end
end

end

