function vr = targetControl(vr,oldWorld)

% calculate the target centroid
xyz = vr.worlds{oldWorld}.surface.vertices(:,vr.doorVertices(1):vr.doorVertices(2));
c = [mean(xyz(1,:)),mean(xyz(2,:))];

% if the player is close enough to the target centroid
if sqrt((c(1)-vr.position(1))^2 + (c(2)-vr.position(2))^2) < 1;
    % deliver the reward
    if isfield(vr,'timeSolenoid')
        reward(vr,vr.timeSolenoid)
        vr.numRewards = vr.numRewards+1;
    end
    % make sure the new position is not too close to the player and the target is not over the boxes
    while sqrt((c(1)-vr.position(1))^2 + (c(2)-vr.position(2))^2) < 5
        % then teleport the target away randomly
        % if the square arena, move the target in x and y
        if str2double(vr.exper.variables.arenaWidth) == str2double(vr.exper.variables.arenaLength)
            vr.worlds{oldWorld}.surface.vertices(1,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorigin(1,:) + .9*(randi(str2double(vr.exper.variables.arenaWidth)) - str2double(vr.exper.variables.arenaWidth)/2);
            vr.worlds{oldWorld}.surface.vertices(2,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorigin(2,:) + .9*(randi(str2double(vr.exper.variables.arenaLength))-str2double(vr.exper.variables.arenaLength)/2);
            xyz = vr.worlds{oldWorld}.surface.vertices(:,vr.doorVertices(1):vr.doorVertices(2));
            c = [mean(xyz(1,:)),mean(xyz(2,:))];
            % if over an east/west box
            if (c(1) > 21 || c(1) < 4) && (c(2) < 15 && c(2) > 10)
                % redraw x position from new, smaller disribution
                vr.worlds{oldWorld}.surface.vertices(1,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorigin(1,:) + .7*(randi(str2double(vr.exper.variables.arenaWidth)) - str2double(vr.exper.variables.arenaWidth)/2);
            % if over a north/south box
            elseif (c(2) > 21 || c(2) < 4) && (c(1) < 15 && c(1) > 10)
                % redraw y position from new, smaller disribution
                vr.worlds{oldWorld}.surface.vertices(2,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorigin(2,:) + .7*(randi(str2double(vr.exper.variables.arenaLength))-str2double(vr.exper.variables.arenaLength)/2);
            end
        else % if not the square arena, move the target only in y
            vr.worlds{oldWorld}.surface.vertices(2,vr.doorVertices(1):vr.doorVertices(2)) = vr.doorigin(2,:) + .9*(randi(str2double(vr.exper.variables.arenaLength))-str2double(vr.exper.variables.arenaLength)/2);
            xyz = vr.worlds{oldWorld}.surface.vertices(:,vr.doorVertices(1):vr.doorVertices(2));
            c = [mean(xyz(1,:)),mean(xyz(2,:))];
        end
    end
end