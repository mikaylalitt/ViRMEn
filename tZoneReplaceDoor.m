function vr = tZoneReplaceDoor(vr,oldWorld,door)
%TZONEDOORCONTROL Summary of this function goes here

% modified from "targetControl.m"
% vr.doorName = [door,'Door'];
% vr.doorIndex = vr.worlds{vr.currentWorld}.objects.indices.doorName;  

if strcmp(door,'left')
    vr.doorIndex = vr.worlds{vr.currentWorld}.objects.indices.leftDoor;  
elseif strcmp(door,'right')
    vr.doorIndex = vr.worlds{vr.currentWorld}.objects.indices.rightDoor;    
elseif strcmp(door,'middle')
    vr.doorIndex = vr.worlds{vr.currentWorld}.objects.indices.middleDoor; 
else
    error('tZoneReplaceDoor not called on door');
end

% get the current position of the door:
vr.doorVertices = vr.worlds{vr.currentWorld}.objects.vertices(vr.doorIndex,:); 
vr.doorOrigin = vr.worlds{oldWorld}.surface.vertices(:,vr.doorVertices(1):vr.doorVertices(2));

xyz = vr.worlds{oldWorld}.surface.vertices(:,vr.doorVertices(1):vr.doorVertices(2));
c = [mean(xyz(1,:)),mean(xyz(2,:))];

% if the player is not near the door
if (vr.position(2) < 22) 
    % move the door outside 
    vr.worlds{oldWorld}.surface.vertices(2,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorOrigin(2,:) - 15; %15 is an arbitrary amount
    if strcmp(door,'left')
        vr.hasleftDoor = true;
    elseif strcmp(door,'right')
        vr.hasrightDoor = true;
    elseif strcmp(door,'middle')
        vr.hasmiddleDoor = true;
    end
end







