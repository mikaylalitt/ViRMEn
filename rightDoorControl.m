function vr = rightDoorControl(vr,oldWorld)

% modified from "targetControl.m"

%  RIGHT DOOR
% calculate the target centroid
right_xyz = vr.worlds{oldWorld}.surface.vertices(:,vr.rdoorVertices(1):vr.rdoorVertices(2));
right_c = [mean(right_xyz(1,:)),mean(right_xyz(2,:))];

% if the player is close enough to the target centroid
if sqrt((right_c(1)-vr.position(1))^2 + (right_c(2)-vr.position(2))^2) < 1;
    % deliver the reward
    if isfield(vr,'timeSolenoid')
        reward(vr,vr.timeSolenoid)
        vr.numRewards = vr.numRewards+1;
    end
    % move the door outside 
    vr.worlds{oldWorld}.surface.vertices(2,vr.rdoorVertices(1):vr.rdoorVertices(2)) = vr.rdoorOrigin(2,:) + 2;
    % make sure the new position is not too close to the player and the target is not over the boxes
end