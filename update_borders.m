function world = update_borders(world)
% world = vr.worlds{vr.currentWorld};

hasBorder = ~isnan(world.edges.radius);
world.walls.endpoints = world.edges.endpoints(hasBorder, :);
world.walls.radius    = world.edges.radius(hasBorder);
world.walls.radius2   = world.edges.radius.^2;
world.walls.angle     = atan2  ( (world.walls.endpoints(:,4) - world.walls.endpoints(:,2))   ...
    , (world.walls.endpoints(:,3) - world.walls.endpoints(:,1)));
world.walls.vector    = [ world.walls.radius .* cos(world.walls.angle + pi/2)               ...
    , world.walls.radius .* sin(world.walls.angle + pi/2)  ];
vector = repmat(world.walls.vector, 1, 2);
world.walls.border1   = world.walls.endpoints + vector;
world.walls.border2   = world.walls.endpoints - vector;

% % change the door's edgeRadius:
% hasBorder = ~isnan(vr.worlds{vr.currentWorld}.edges.radius); % true if the edgeRadius is something other than NaN
% vr.worlds{vr.currentWorld}.edges.radius(vr.doorNum) = NaN;
% vr.worlds{vr.currentWorld}.walls.endpoints = vr.worlds{vr.currentWorld}.edges.endpoints(hasBorder, :); % array consisting of the four endpoints associated with every wall that has a non-NaN edge
% vr.worlds{vr.currentWorld}.walls.radius    = vr.worlds{vr.currentWorld}.edges.radius(hasBorder); % values of edgeRadius (wallThickness which is 0.5) for every wall
% vr.worlds{vr.currentWorld}.walls.radius2   = vr.worlds{vr.currentWorld}.edges.radius.^2; % squares the value of the edgeRadius (0.25 for edgeRadius of 0.5)
% vr.worlds{vr.currentWorld}.walls.angle     = atan2  ( (vr.worlds{vr.currentWorld}.walls.endpoints(:,4) - vr.worlds{vr.currentWorld}.walls.endpoints(:,2))   ...
%     , (vr.worlds{vr.currentWorld}.walls.endpoints(:,3) - vr.worlds{vr.currentWorld}.walls.endpoints(:,1))); % angle of every wall?
% vr.worlds{vr.currentWorld}.walls.vector    = [ vr.worlds{vr.currentWorld}.walls.radius .* cos(vr.worlds{vr.currentWorld}.walls.angle + pi/2)               ...
%     , vr.worlds{vr.currentWorld}.walls.radius .* sin(vr.worlds{vr.currentWorld}.walls.angle + pi/2)  ];
% vector = repmat(vr.worlds{vr.currentWorld}.walls.vector, 1, 2);
% vr.worlds{vr.currentWorld}.walls.border1   = vr.worlds{vr.currentWorld}.walls.endpoints + vector;
% vr.worlds{vr.currentWorld}.walls.border2   = vr.worlds{vr.currentWorld}.walls.endpoints - vector;