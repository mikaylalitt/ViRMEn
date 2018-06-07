function code = tZone_continuous_experiment3
% this is modified from singleSquareArena to include the t-shape rewards
% singleSquareArena   Code for the ViRMEn experiment singleSquareArena.
%   code = singleSquareArena   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT



% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)

% % which version of the three continuous experiments to run:
vr.experimentV1 = false;
vr.experimentV2 = false;
vr.experimentV3 = true;

vr = initializeDAQ_arenaTZone(vr);

% set number of rewards
vr.numRewards = 0;

% set the amount of water (uL) that each reward gives
vr.waterPerReward = 4; 

% set properties of the reward
vr.timeSolenoid = 16; % in milliseconds
vr.rewardsOn = 1;

% set starting positions
vr.prevY_Posn = 8; % y-coordinate of initial conditions of world
vr.prevX_Posn = 0; % x-coordinate of initial conditions of world
vr.currHall = 'main'; % which hall the mouse is in to start with
vr.prevHall = ''; % the hall the mouse was in previously, which is none to start
vr.hasReset = false; % if the mouse has used the return halls and gone back through the main (middle) hall 

% set properties of the arena
% the main hall of the T-Maze should be centered on 0 of the x-axis and
% it should start on 0 of the y-axis 
vr.arenaLength = str2double(vr.exper.variables.arenaLength);
vr.arenaWidth = str2double(vr.exper.variables.arenaWidth);

% specifically for version 2:
if vr.experimentV2
    % move the right door out initially
    vr = tZoneRemoveDoor(vr, vr.currentWorld, 'movingRight');
end

% specifically for version 3:
if vr.experimentV3
    vr.prevRewardSide = 'none';
end

% % initially there are doors at the beginning blocking the return paths
% % this prevents the animal from going the wrong way if it gets turned around
% % at the beginning
vr.hasrightInitialDoor = true;
vr.hasleftInitialDoor = true;

% set ball movement
vr.scaling = [33.5, 7.5]; % forward gain, angular gain for ball movement

% initialize starting variables
vr.starting = true;
vr.startTime = now;
vr.gaveFirstReward = false;
vr.initialDropsToSend = 1;
vr.dropsToSend = 1;



% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

% if vr.starting
%     vr = tZoneRemoveDoor(vr, vr.currentWorld, 'movingRight');
%     vr.starting = false;
% end

% keep track of if the mouse is eligible for a reward
% i.e. if the mouse has returned to start through return hall and gone back
% through the main hall (it has gone back through the starting position)
if (strcmp(vr.currHall,'main')... 
        && (vr.position(2) > 12.5 && vr.position(2) < 15)... % these are arbitrary numbers to check that the mouse has passed a certain point in the main hall
        && (strcmp(vr.prevHall,'') || strcmp(vr.prevHall,'leftReturn') || strcmp(vr.prevHall,'rightReturn')))
    vr.hasReset = true;
end

% keep track of which hall the mouse is currently in and was in previously
if (vr.position(1) > -(vr.arenaWidth/2) && vr.position(1) < (vr.arenaWidth/2)) % checking to see if the mouse is in the main hall (via the width of the main hall)
    if (vr.prevX_Posn < -(vr.arenaWidth/2) || vr.prevX_Posn > (vr.arenaWidth/2))
        vr.prevHall = vr.currHall;
    end
    vr.currHall = 'main';
elseif (vr.position(1) < -(vr.arenaWidth/2))
    if (vr.position(2) > (vr.arenaLength-vr.arenaWidth))  % checking to see if the mouse is in left TZone hall
        if (vr.prevX_Posn > -(vr.arenaWidth/2) || vr.prevY_Posn < (vr.arenaLength-vr.arenaWidth))
            vr.prevHall = vr.currHall;
        end
        vr.currHall = 'leftTZone';
    else
        if (vr.prevX_Posn > -(vr.arenaWidth/2) || vr.prevY_Posn > (vr.arenaLength-vr.arenaWidth))
            vr.prevHall = vr.currHall;
        end
        vr.currHall = 'leftReturn';
    end
elseif (vr.position(1) > (vr.arenaWidth/2))
    if (vr.position(2) > (vr.arenaLength-vr.arenaWidth)) % checking to see if the mouse is in right TZone hall
        if (vr.prevX_Posn < (vr.arenaWidth/2) || vr.prevY_Posn < (vr.arenaLength-vr.arenaWidth))
            vr.prevHall = vr.currHall;
        end
        vr.currHall = 'rightTZone';
    else
        if (vr.prevX_Posn < (vr.arenaWidth/2) || vr.prevY_Posn > (vr.arenaLength-vr.arenaWidth))
            vr.prevHall = vr.currHall;
        end
        vr.currHall = 'rightReturn';
    end
end

% remove the initial doors blocking the return pathways once the mouse gets past a certain x-value:
if (vr.position(1) > 20) || (vr.position(1) < -20) % 20 is an arbitrary amount, can be changed
    if vr.hasleftInitialDoor
        vr = tZoneRemoveDoor(vr, vr.currentWorld, 'left');
    end 
    
    if vr.hasrightInitialDoor
        vr = tZoneRemoveDoor(vr, vr.currentWorld, 'right');
    end
    
end

% % for testing door control:
% if vr.position(1) < -5 && vr.hastestDoor
%     vr = openDoor(vr, vr.currentWorld, 'remove');
%     vr.hastestDoor = false;
% end
% 
% if vr.position(1) > 5 && ~vr.hastestDoor
%     vr = openDoor(vr, vr.currentWorld, 'replace');
%     vr.hastestDoor = true;
% end

if vr.rewardsOn && vr.hasReset
    % check if the animal is in the left reward zone:
    if ((vr.position(1) < -(vr.arenaLength-vr.arenaWidth)) && (vr.position(2) > (vr.arenaLength-vr.arenaWidth)))
        % make sure that it went through the main hall and top left hall to get there:
        if (vr.prevX_Posn > -(vr.arenaLength-vr.arenaWidth) && strcmp(vr.prevHall,'main'))
            % check if the animal alternated sides:
            if vr.experimentV3 && strcmp(vr.prevRewardSide, 'left')
                disp('**Did not alternate sides so no reward given**');
            else  
                % deliver reward
                vr = reward(vr);
                disp('REWARD LEFT');
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
    end
    
    % check if the animal is in the right reward zone:
    if ((vr.position(1) > (vr.arenaLength-vr.arenaWidth)) && (vr.position(2) > (vr.arenaLength-vr.arenaWidth)))
        if (vr.prevX_Posn < (vr.arenaLength-vr.arenaWidth) && strcmp(vr.prevHall,'main'))
            if vr.experimentV3 && strcmp(vr.prevRewardSide, 'right')
                disp('**Did not alternate sides so no reward given**');
            else
                % deliver reward
                vr = reward(vr);
                disp('REWARD RIGHT');
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
    end
    
end

% update previous positions:
vr.prevY_Posn = vr.position(2);
vr.prevX_Posn = vr.position(1);



% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)

try stop(vr.moveRecordingSession);           catch ME; end
try stop(vr.moveSession);                    catch ME; end
try stop(vr.moveRecordingSession);           catch ME; end
try stop(vr.waterSession);                   catch ME; end
try stop(vr.ballMovement);                   catch ME; end

% report how much water was delivered and how many rewards were earned
disp(strcat(num2str(vr.numRewards), ' rewards given NOT including the initial one'));
disp(['That is ', num2str(vr.numRewards*vr.waterPerReward), ' uL of water']); % not sure if this number is correct?
fclose('all'); % close save files



% % CODE TAKEN OUT:
% % originally in initialization code:
% % under vr = initializeDAQ_arenaTZone(vr) was the following code:
% % replay a previous movement session (for testing purposes)
% if vr.replayMovement
% %     load('positionSweeps1');
% %     load('yPositionReplay.mat'); % load movement to replay
%     load('positionsViewAnglesReplay.mat');
% %     load('yPositionReplayPt02mPerSecBack.mat'); % load movement to replay
% %     vr.yPositionReplay = smooth(yPositionReplay,49);
%     vr.yPositionReplay = yPositions;
%     vr.viewAnglesReplay = viewAngles;
%     clear yPositionReplay yPositions viewAngles % clear redundant variable
%     vr.time = 0; % initialize time as 0
% %     c = 3.4;
% %     vr.times = nan(round(length(vr.yPositionReplay)/c),1); % initialize vector of times to record
% %     vr.yPositions = nan(round(length(vr.yPositionReplay)/3.76),1); % initialize vector of positions to record
% %     vr.yPositions = nan(round(length(vr.yPositionReplay)/c),1); % initialize vector of positions to record
% %     vr.viewAngles = nan(round(length(vr.yPositionReplay)/c),1); % initialize vector of positions to record
%     vr.timeIndex = 1; % index to keep track of the time 
% end

% vr.yVelocityReverseTimepoints = 10;
% vr.previousYPositions = zeros(vr.yVelocityReverseTimepoints+1,1);
% vr.previousViewAngles = zeros(vr.yVelocityReverseTimepoints+1,1);
% vr.previousDeltaTimes = zeros(vr.yVelocityReverseTimepoints,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % originally in runtime code:
% deliver initial reward:
% if ~vr.gaveFirstReward
%     disp('First Reward');
%     for drop = 1:1
%         queueOutputData(vr.waterSession,[ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
%         startBackground(vr.waterSession);
%     end
%     vr.gaveFirstReward = true;
%     vr.numRewards = vr.numRewards+1;
% end

% % above deliver reward function was:
% % update position and dt buffers
% vr.previousYPositions(1:end-1) = vr.previousYPositions(2:end);
% vr.previousYPositions(end) = vr.position(2);
% 
% vr.position(4) = mod(vr.position(4),2*pi); % bound angle to 0:2pi
% vr.previousViewAngles(1:end-1) = vr.previousViewAngles(2:end);
% vr.previousViewAngles(end) = vr.position(4);
% 
% vr.previousDeltaTimes(1:end-1) = vr.previousDeltaTimes(2:end);
% vr.previousDeltaTimes(end) = vr.dt;

% % if this session is a replay of previously-recordded movement % BAR
% if vr.replayMovement && vr.dt > 0
%     vr.time = vr.time + vr.dt; % update the time
%     if vr.time < length(vr.yPositionReplay)/1000 % if still replaying
%         vr.position(2) = vr.yPositionReplay(round(vr.time*1000)); % update the position
%         vr.position(4) = vr.viewAnglesReplay(round(vr.time*1000)); % update the position
% 
%         % store position, angle, and time if desired.  this is only used
%         % for optmizing the predictive algorithm offline afterward
% %         vr.yPositions(vr.timeIndex) = vr.position(2); % store the position
% %         vr.viewAngles(vr.timeIndex) = vr.position(4); % store the view angle
% %         vr.times(vr.timeIndex) = vr.time; % store the time
% %         vr.timeIndex = vr.timeIndex + 1; % update the index 
%     else
%         vr.experimentEnded = true; % end the experiment
%     end
% end


