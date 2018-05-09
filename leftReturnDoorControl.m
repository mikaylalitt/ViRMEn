function vr = leftReturnDoorControl(vr,oldWorld)

% modified from "targetControl.m"

%  LEFT RETURN DOOR
% calculate the centroid of the end wall
end_xyz = vr.worlds{oldWorld}.surface.vertices(:,vr.ldoorVertices(1):vr.ldoorVertices(2));
end_c = [mean(end_xyz(1,:)),mean(end_xyz(2,:))];

% if the player is close enough to the target centroid
if sqrt((end_c(1)-vr.position(1))^2 + (end_c(2)-vr.position(2))^2) < 1;
    % deliver the reward
    if isfield(vr,'timeSolenoid')
        reward(vr,vr.timeSolenoid)
        vr.numRewards = vr.numRewards+1;
    end
    
    %move the door outside the arena
    vr.worlds{oldWorld}.surface.vertices(2,vr.ldoorVertices(1):vr.ldoorVertices(2)) = vr.ldoorOrigin(2,:) + 2;    
end
