function vr = leftDoorControl(vr,oldWorld)

% modified from "targetControl.m"

%  LEFT DOOR
% calculate the target centroid
left_xyz = vr.worlds{oldWorld}.surface.vertices(:,vr.ldoorVertices(1):vr.ldoorVertices(2));
left_c = [mean(left_xyz(1,:)),mean(left_xyz(2,:))];

% if the player is close enough to the target centroid
if sqrt((left_c(1)-vr.position(1))^2 + (left_c(2)-vr.position(2))^2) < 1;
    % deliver the reward
    if isfield(vr,'timeSolenoid')
        reward(vr,vr.timeSolenoid)
        vr.numRewards = vr.numRewards+1;
    end
    
    %move the door outside the arena
    vr.worlds{oldWorld}.surface.vertices(2,vr.ldoorVertices(1):vr.ldoorVertices(2)) = vr.ldoorOrigin(2,:) + 2;    
    vr.hasleftDoor = 0;
end
