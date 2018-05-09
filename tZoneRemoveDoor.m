function vr = tZoneRemoveDoor(vr,oldWorld,door)
%TZONEDOORCONTROL Summary of this function goes here

% modified from "targetControl.m"

if strcmp(door,'left')
    % determine the index of the door:
    vr.doorIndex = vr.worlds{vr.currentWorld}.objects.indices.leftInitialDoor; 
    vr.doorNum = 24; % this number depends on the index of the door in the array: vr.worlds{vr.currentWorld}.edges
    vr.hasleftInitialDoor = false;
elseif strcmp(door,'right')
    vr.doorIndex = vr.worlds{vr.currentWorld}.objects.indices.rightInitialDoor;
    vr.doorNum = 23;
    vr.hasrightInitialDoor = false;
elseif strcmp(door, 'movingRight')
    vr.doorIndex = vr.worlds{vr.currentWorld}.objects.indices.movingRightDoor;
    vr.doorNum = 26;
else
    error('tZoneDoorRemoveDoor not called on door');
end

% determine the indices of the first and last vertex of door:
vr.doorVertices = vr.worlds{vr.currentWorld}.objects.vertices(vr.doorIndex,:); 
vr.doorOrigin = vr.worlds{oldWorld}.surface.vertices(:,vr.doorVertices(1):vr.doorVertices(2)); 

% move the doors:
if strcmp(door, 'movingRight')
    vr.worlds{oldWorld}.surface.vertices(2,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorOrigin(2,:) + 10; %15 is an arbitrary amount
else
    vr.worlds{oldWorld}.surface.vertices(2,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorOrigin(2,:) + 100; %15 is an arbitrary amount
end

% change the door's edgeRadius:
vr.worlds{vr.currentWorld}.edges.radius(vr.doorNum) = NaN;

% update world edges:
vr.worlds{vr.currentWorld} = update_borders(vr.worlds{vr.currentWorld});

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

% % determine the indices of the first and last vertex of door:
% vr.doorVertices = vr.worlds{vr.currentWorld}.objects.vertices(vr.doorIndex,:); 
% vr.doorOrigin = vr.worlds{oldWorld}.surface.vertices(:,vr.doorVertices(1):vr.doorVertices(2)); 
% 
% % % move the doors:
% % if strcmp(door, 'movingRight')
% %     vr.worlds{oldWorld}.surface.vertices(2,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorOrigin(2,:) + 10; %15 is an arbitrary amount
% % else
% %     vr.worlds{oldWorld}.surface.vertices(2,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorOrigin(2,:) + 30; %15 is an arbitrary amount
% % end

% % for testing:
% vr.doorIndexArray = vr.doorVertices(1):vr.doorVertices(2); % page 32 of help manual
% vr.worlds{vr.currentWorld}.surface.colors(3,vr.doorIndexArray) = 0;

% xyz = vr.worlds{oldWorld}.surface.vertices(:,vr.doorVertices(1):vr.doorVertices(2));
% c = [mean(xyz(1,:)),mean(xyz(2,:))];

% % if the player is close enough to the target centroid
% if (sqrt((c(1)-vr.position(1))^2 + (c(2)-vr.position(2))^2) < 1)
%     % move the door outside 
%     vr.worlds{oldWorld}.surface.vertices(2,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorOrigin(2,:) + 15; %15 is an arbitrary amount
% end





