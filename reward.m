% function reward(vr,rewardTime)
% queueOutputData(vr.waterSession,[ones(1,rewardTime)*vr.highVoltage vr.lowVoltage]'); 
% % vr.waterSession is the data acquisition session
% % "ones(1,rewardTime)" returns a 1 by 1 array of ones of data type rewardTime
% startBackground(vr.waterSession);

% ML commented out above and added below based off of:
% "alternateEndZoneReward.m"

function vr = reward(vr)

% ML 
if ((vr.position(1) < -23) && (vr.position(2) > 23)) % mouse is in left reward zone
%     reward(vr,vr.timeSolenoid);
    if ((vr.prevY_Posn < 23 || vr.prevX_Posn > -23) && strcmp(vr.prevHall,'main'))
        if vr.experimentV3
            if strcmp(vr.prevRewardSide, 'left')
                disp('Did not alternate sides so no reward given');
                return
            end
        end
        % deliver reward:
        disp('REWARD LEFT');
%         calibrateWaterReward(21,4,9,0);
        for drop = 1:vr.dropsToSend
            queueOutputData(vr.waterSession,[ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
            startBackground(vr.waterSession);
        end

%         queueOutputData(vr.waterSession,[ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
%         startBackground(vr.waterSession);

        % count the reward:
        vr.numRewards = vr.numRewards+1;
        % the mouse has to reset before getting another reward:
        vr.hasReset = false;
        % keep track of which side the reward was last delivered on:
        if vr.experimentV3
            vr.prevRewardSide = 'left';
        end
        % switch which side the door is on
        if vr.experimentV2
            vr = switchDoor(vr, vr.currentWorld, 'leftHall');
        end
    end
end

if ((vr.position(1) > 23) && (vr.position(2) > 23)) % mouse is in right reward zone
%     reward(vr,vr.timeSolenoid);
    if ((vr.prevY_Posn < 23 || vr.prevX_Posn < 23) && strcmp(vr.prevHall,'main'))
        if vr.experimentV3
            if strcmp(vr.prevRewardSide, 'right')
                disp('Did not alternate sides so no reward given');
                return
            end
        end
        % deliver reward:
        disp('REWARD RIGHT');
        for drop = 1:vr.dropsToSend
            queueOutputData(vr.waterSession,[ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
            startBackground(vr.waterSession);
        end
%         queueOutputData(vr.waterSession,[ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
%         startBackground(vr.waterSession);

        % count the reward:
        vr.numRewards = vr.numRewards+1;
        % the mouse has to reset before getting another reward:
        vr.hasReset = false;
        % keep track of which side the reward was last delivered on:
        if vr.experimentV3
            vr.prevRewardSide = 'right';
        end
        % switch which side the door is on
        if vr.experimentV2
            vr = switchDoor(vr, vr.currentWorld, 'rightHall');
        end 
    end
end
