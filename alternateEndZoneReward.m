function vr = alternateEndZoneReward(vr)

% locations of the endzone boundaries
% (these should be updated based on the locations of the endzones of the track being used):
vr.endZoneLoc1 = str2double(vr.exper.variables.arenaLength)-str2double(vr.exper.variables.endZoneLength);
vr.endZoneLoc2 = str2double(vr.exper.variables.endZoneLength);

% if the mouse is in the opposite endzone as before, deliver a reward 
% (for the linear track only the y-position of the mouse needs to be compared):
if (vr.position(2) > vr.endZoneLoc1) && (vr.lastEndZoneRewarded == 1 || ~vr.gaveFirstReward)
    
    if ~vr.gaveFirstReward % if this is the first reward
       vr.gaveFirstReward = true;
    end
    
    vr.lastEndZoneRewarded = 2; % update the last endzone that was rewarded to be this endzone
    vr = reward(vr); % deliver the reward
    
elseif (vr.position(2) < vr.endZoneLoc2) && (vr.lastEndZoneRewarded == 2 || ~vr.gaveFirstReward)
    
    if ~vr.gaveFirstReward
       vr.gaveFirstReward = true;
    end
    
    vr.lastEndZoneRewarded = 1; 
    vr = reward(vr);
    
end

% ---------------------------------------------------------- above is the newly edited code and below is the old code

% queueOutputData(vr.waterSession,[ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
% startBackground(vr.waterSession);
    
% % update the previous endzone visited
% vr.lastEndZoneRewarded = mod(vr.lastEndZoneRewarded,2) + 1;
    
% % count the reward
% vr.numRewards = vr.numRewards + 1;
    
% disp('REWARD');
% vr.gaveFirstReward = true;
