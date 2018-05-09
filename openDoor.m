% function vr = openDoor(vr)
% 
% if(vr.position(1)<-5)            %%MASTER LOOP FOR DOOR BAR JPB FOR MARK 
%     vr.worlds{vr.currentWorld}.surface.vertices(1,vr.doorVertices(1):vr.doorVertices(2)) = vr.worlds{vr.currentWorld}.surface.vertices(1,vr.doorVertices(1):vr.doorVertices(2))+ 100;
% %         if vr.position(2) >50 %%BAR and JPB added
% %             vr.worlds{oldWorld}.surface.vertices(1,vr.doorVertices(1):vr.doorVertices(2)) = vr.worlds{oldWorld}.surface.vertices(1,vr.doorVertices(1):vr.doorVertices(2))+vr.doorSpeed;
% %         else
% %               vr.worlds{oldWorld}.surface.vertices(1,vr.doorVertices(1):vr.doorVertices(2))  = vr.doorigin;
% %         end
% end
function vr = openDoor(vr,oldWorld,action)

 % change the door's position:
 vr.doorIndex = vr.worlds{vr.currentWorld}.objects.indices.testDoor;
 vr.doorVertices = vr.worlds{vr.currentWorld}.objects.vertices(vr.doorIndex,:); 
 vr.doorOrigin = vr.worlds{oldWorld}.surface.vertices(:,vr.doorVertices(1):vr.doorVertices(2));
 vr.doorIndexArray = vr.doorVertices(1):vr.doorVertices(2); % page 32 of help manual

if strcmp(action, 'remove')
    % change the door's edgeRadius
    hasBorder = ~isnan(vr.worlds{vr.currentWorld}.edges.radius); % true if the edgeRadius is something other than NaN
    vr.worlds{vr.currentWorld}.edges.radius(25) = NaN;
    vr.worlds{vr.currentWorld}.walls.endpoints = vr.worlds{vr.currentWorld}.edges.endpoints(hasBorder, :); % array consisting of the four endpoints associated with every wall that has a non-NaN edge
    vr.worlds{vr.currentWorld}.walls.radius    = vr.worlds{vr.currentWorld}.edges.radius(hasBorder); % values of edgeRadius (wallThickness which is 0.5) for every wall
    vr.worlds{vr.currentWorld}.walls.radius2   = vr.worlds{vr.currentWorld}.edges.radius.^2; % squares the value of the edgeRadius (0.25 for edgeRadius of 0.5)
    vr.worlds{vr.currentWorld}.walls.angle     = atan2  ( (vr.worlds{vr.currentWorld}.walls.endpoints(:,4) - vr.worlds{vr.currentWorld}.walls.endpoints(:,2))   ...
        , (vr.worlds{vr.currentWorld}.walls.endpoints(:,3) - vr.worlds{vr.currentWorld}.walls.endpoints(:,1))); % angle of every wall?
    vr.worlds{vr.currentWorld}.walls.vector    = [ vr.worlds{vr.currentWorld}.walls.radius .* cos(vr.worlds{vr.currentWorld}.walls.angle + pi/2)               ...
        , vr.worlds{vr.currentWorld}.walls.radius .* sin(vr.worlds{vr.currentWorld}.walls.angle + pi/2)  ];
    vector = repmat(vr.worlds{vr.currentWorld}.walls.vector, 1, 2);
    vr.worlds{vr.currentWorld}.walls.border1   = vr.worlds{vr.currentWorld}.walls.endpoints + vector;
    vr.worlds{vr.currentWorld}.walls.border2   = vr.worlds{vr.currentWorld}.walls.endpoints - vector;

    % change the door's position:
    % vr.worlds{vr.currentWorld}.surface.colors(3,vr.doorIndexArray) = 0; % changes the color of the door --> for testing to make sure this function is even getting called
    vr.worlds{oldWorld}.surface.vertices(2,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorOrigin(2,:) + 100;
    vr.hastestDoor = false;
end

if strcmp(action, 'replace')
    vr.worlds{vr.currentWorld}.edges.radius(25) = 0.5;
    hasBorder = ~isnan(vr.worlds{vr.currentWorld}.edges.radius);
    vr.worlds{vr.currentWorld}.walls.endpoints = vr.worlds{vr.currentWorld}.edges.endpoints(hasBorder, :); % array consisting of the four endpoints associated with every wall that has a non-NaN edge
    vr.worlds{vr.currentWorld}.walls.radius    = vr.worlds{vr.currentWorld}.edges.radius(hasBorder); % values of edgeRadius (wallThickness which is 0.5) for every wall in above array
    disp(vr.worlds{vr.currentWorld}.walls.radius);
    vr.worlds{vr.currentWorld}.walls.radius2   = vr.worlds{vr.currentWorld}.edges.radius.^2; % squares the value of the edgeRadius (0.25 for edgeRadius of 0.5)
    vr.worlds{vr.currentWorld}.walls.angle     = atan2  ( (vr.worlds{vr.currentWorld}.walls.endpoints(:,4) - vr.worlds{vr.currentWorld}.walls.endpoints(:,2))   ...
        , (vr.worlds{vr.currentWorld}.walls.endpoints(:,3) - vr.worlds{vr.currentWorld}.walls.endpoints(:,1))); % angle of every wall?
    vr.worlds{vr.currentWorld}.walls.vector    = [ vr.worlds{vr.currentWorld}.walls.radius .* cos(vr.worlds{vr.currentWorld}.walls.angle + pi/2)               ...
        , vr.worlds{vr.currentWorld}.walls.radius .* sin(vr.worlds{vr.currentWorld}.walls.angle + pi/2)  ];
    vector = repmat(vr.worlds{vr.currentWorld}.walls.vector, 1, 2);
    vr.worlds{vr.currentWorld}.walls.border1   = vr.worlds{vr.currentWorld}.walls.endpoints + vector;
    vr.worlds{vr.currentWorld}.walls.border2   = vr.worlds{vr.currentWorld}.walls.endpoints - vector;

    % change the door's position:
    % vr.worlds{vr.currentWorld}.surface.colors(3,vr.doorIndexArray) = 0; % changes the color of the door --> for testing to make sure this function is even getting called
    vr.worlds{oldWorld}.surface.vertices(2,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorOrigin(2,:) - 100;
    
    vr.hastestDoor = true;
end

