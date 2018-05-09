function vr = alternateEndZoneReward(vr)

queueOutputData(vr.waterSession,[ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
startBackground(vr.waterSession);
    
% update the previous endzone visited
vr.lastEndZoneRewarded = mod(vr.lastEndZoneRewarded,2) + 1;
    
% count the reward
vr.numRewards = vr.numRewards + 1;
    
disp('REWARD');
vr.gaveFirstReward = true;

% % if the mouse is in the opposite endzone from before
% if (((vr.position(2) > str2double(vr.exper.variables.arenaLength)-str2double(vr.exper.variables.endZoneLength)) ...
%         && (lastEndZoneRewarded == 1 || ~vr.gaveFirstReward))...
%         || (vr.position(2) < str2double(vr.exper.variables.endZoneLength) ...
%         && (vr.lastEndZoneRewarded == 2 || ~vr.gaveFirstReward)))
%     
%     % deliver the reward
% %     try
% %         for drop=1:vr.dropsToSend
% % %             queueOutputData(vr.waterSession,[ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
% % %             startBackground(vr.waterSession);
% %             vr.waterSession.queueOutputData([ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
% %             vr.lh = vr.waterSession.addlistener('DataAvailable',@(src,event) test2(src, event));
% %             vr.waterSession.startBackground
% %             lh.Enabled = false;
% %             delete(lh);
% %             vr.waterSession.wait();
% %         end
% %     catch err
% %         queueOutputData(vr.waterSession,[ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
% %         startBackground(vr.waterSession);
% %     end
% 
%    % deliver the reward
%     queueOutputData(vr.waterSession,[ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
%     startBackground(vr.waterSession);
%     
%     % update the previous endzone visited
%     vr.lastEndZoneRewarded = mod(vr.lastEndZoneRewarded,2) + 1;
%     
%     % count the reward
%     vr.numRewards = vr.numRewards + 1;
%     
%     disp('REWARD');
%     vr.gaveFirstReward = true;
% end
