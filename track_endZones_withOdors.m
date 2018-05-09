
function code = track_endZones_withOdors
% this is modified from singleSquareArena to include odors
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

% set the halfway points of the graph
vr.halfwayPoint = str2double(vr.exper.variables.arenaLength)/2;

% set and calculate properties of each odor
vr.lowestFlowFraction = .01; % this is the lowest possible flow rate. should be non-zero to prevent backflow
vr.odor1sourceLocation = [str2double(vr.exper.variables.arenaWidth)/2, str2double(vr.exper.variables.arenaLength) - str2double(vr.exper.variables.wallThickness)]; % where the odor concentration is maximal
vr.odor2sourceLocation = [str2double(vr.exper.variables.arenaWidth)/2, str2double(vr.exper.variables.wallThickness)]; % where the odor concentration is maximal
x=[0,str2double(vr.exper.variables.arenaLength) - 2*str2double(vr.exper.variables.wallThickness)]; % y position only for the linear track
y=[1,vr.lowestFlowFraction].*100; % max and min flow fraction
vr.flowVsDistanceConstants = polyfit(x,y,1); % constants c1 and c2 for flow = c1/x + c2
clear x y lowestFlowFraction;

% choose the type of experiment this will start as
vr.odorGradientOn = 1;
vr.odorPredictionOn = 0;
vr.noiseExperiment = 0;
vr.replayMovement = 1;
vr.lightsOn = 1;
vr.darknessTrigger = 0;
vr.odorFlattenTrigger = 0;
vr.rewardsOn = 1; % switch to 1 for rewards

% initialize the data acquisition cards
vr = initializeDAQ_withOdors_smooth(vr);

% replay a previous movement session (for testing purposes)
if vr.replayMovement
%     load('positionSweeps1');
%     load('yPositionReplay.mat'); % load movement to replay
    load('positionsViewAnglesReplay.mat');
%     load('yPositionReplayPt02mPerSecBack.mat'); % load movement to replay
%     vr.yPositionReplay = smooth(yPositionReplay,49);
    vr.yPositionReplay = yPositions;
    vr.viewAnglesReplay = viewAngles;
    clear yPositionReplay yPositions viewAngles % clear redundant variable
    vr.time = 0; % initialize time as 0
%     c = 3.4;
%     vr.times = nan(round(length(vr.yPositionReplay)/c),1); % initialize vector of times to record
%     vr.yPositions = nan(round(length(vr.yPositionReplay)/3.76),1); % initialize vector of positions to record
%     vr.yPositions = nan(round(length(vr.yPositionReplay)/c),1); % initialize vector of positions to record
%     vr.viewAngles = nan(round(length(vr.yPositionReplay)/c),1); % initialize vector of positions to record
    vr.timeIndex = 1; % index to keep track of the time 
end

% set properties of the predictive algorithm
vr.odorDelay1 = .148; % seconds, for MFC1 (usually methyl valerate)
vr.odorDelay2 = .183; % seconds, for MFC2 (usually alpha pinene)
% vr.odorDelay1 = .097; % seconds, for MFC1 (usually methyl valerate)
% vr.odorDelay2 = .098; % seconds, for MFC2 (usually alpha pinene)
% vr.odorDelay1 = .072; % seconds, for MFC1 (usually methyl valerate)
% vr.odorDelay2 = .073; % seconds, for MFC2 (usually alpha pinene)

vr.yVelocityReverseTimepoints = 10;
vr.previousYPositions = zeros(vr.yVelocityReverseTimepoints+1,1);
vr.previousViewAngles = zeros(vr.yVelocityReverseTimepoints+1,1);
vr.previousDeltaTimes = zeros(vr.yVelocityReverseTimepoints,1);

% set properties of the reward
vr.timeSolenoid = 16; % in milliseconds
vr.lastEndZoneRewarded = 4; % previous reward delivery location. 1 is south end, 2 is north end, 4 is a trick to give a reward when the VR starts

% set number of rewards
vr.numRewards = 0;

% set ball movement
vr.scaling = [19.7,2.2]; % 2 meter track

% set the initial light or odor gradient
if ~vr.lightsOn
    vr.worlds{vr.currentWorld}.surface.visible(:) = false;
else
    vr.worlds{vr.currentWorld}.surface.visible(:) = true;
end
if ~vr.odorGradientOn
    vr = flattenOdorGradients(vr);
end

if vr.noiseExperiment
    % load ideal distributions of odor and flow
    load('odorantNoisyDistributions40to60RangePt020Amp.mat');
%     load('odorantNoisyDistributions25to75RangePt3Amp.mat');
    vr.moveDirectionPrevious = inf; % southward
    vr.timeLastTurnAround = inf;
    % define file for saving the noise index and timestamp
    formatOut = 'dd-mmm-yyyy HH-MM-SS';
    vr.fileID = fopen(['C:\Users\dombeck_lab\Desktop\Brad\noisyDistributionIndices\noiseDistributionIndices_',datestr(now,formatOut),'.txt'],'w');
    fprintf(vr.fileID,'%12.8f %12.8f\r\n',[1,0.001]);
    vr.t = 0; % timestamp
else
    load('odorantLinearDistributions.mat');
end
vr.noiseChoice = 1; % choose the first noisy distribution
% vr.dFlowVsDPidSlope = [.041521, .054711]; % constant for converting dPID/dt to flow for delays [.148,.183]
vr.dFlowVsDPidSlope = [.051157, .056713]; % constant for converting dPID/dt to flow for delays [.097,.098]
% vr.dFlowVsDPidSlope = [.072751, .070334]; % constant for converting dPID/dt to flow for delays [.072,.073]

vr.idealPidVsPosition = idealPid;
vr.idealFlowVsPosition = idealFlow;
vr.idealPosition = linspace(.5,24.5,size(idealFlow{1},2));
    
vr.startTime = now;

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

% update position and dt buffers
vr.previousYPositions(1:end-1) = vr.previousYPositions(2:end);
vr.previousYPositions(end) = vr.position(2);

vr.position(4) = mod(vr.position(4),2*pi); % bound angle to 0:2pi
vr.previousViewAngles(1:end-1) = vr.previousViewAngles(2:end);
vr.previousViewAngles(end) = vr.position(4);

vr.previousDeltaTimes(1:end-1) = vr.previousDeltaTimes(2:end);
vr.previousDeltaTimes(end) = vr.dt;

% added predictive and non-predictive odor delivery BAR
if vr.odorGradientOn && vr.iterations > vr.yVelocityReverseTimepoints % must be after the first iteration to calculate v
    if vr.odorPredictionOn
%         vr = deliverPredictedFlows_1D(vr);
        vr = deliverPredictedOdorantConcentrations_1D(vr);
    else
%         vr = deliverFlows_1D(vr);
        vr = deliverFlowsAnyDistribution_1D(vr);
    end
else
     vr = flattenOdorGradients(vr);
end

% if this session is a replay of previously-recordded movement % BAR
if vr.replayMovement && vr.dt > 0
    vr.time = vr.time + vr.dt; % update the time
    if vr.time < length(vr.yPositionReplay)/1000 % if still replaying
        vr.position(2) = vr.yPositionReplay(round(vr.time*1000)); % update the position
        vr.position(4) = vr.viewAnglesReplay(round(vr.time*1000)); % update the position

        % store position, angle, and time if desired.  this is only used
        % for optmizing the predictive algorithm offline afterward
%         vr.yPositions(vr.timeIndex) = vr.position(2); % store the position
%         vr.viewAngles(vr.timeIndex) = vr.position(4); % store the view angle
%         vr.times(vr.timeIndex) = vr.time; % store the time
%         vr.timeIndex = vr.timeIndex + 1; % update the index 
    else
        vr.experimentEnded = true; % end the experiment
    end
end

% switch all odor flows to their middle value with a keystroke if desired
% switch vr.keyPressed
%     case 264 % down for shut down odors:  flatten odor gradient
%         vr.odorFlattenTrigger = 1;
%     case 265 % up for bring odors back up
%         vr.odorGradientOn = 1; % turn on the gradient
%         vr.odorFlattenTrigger = 0; % turn off the trigger for flattening
%         vr.odorPredictionOn = 1; % turn on predictive algorithm
%     case 263 % left for turn off lights, left hand of darkness
%         vr.darknessTrigger = 1;
% %         vr.worlds{vr.currentWorld}.surface.visible(:) = false;
%     case 262 % rightness for brightness
%         vr.odorPredictionOn = 0; % right for plight of the predictive algorithm
% %         vr.ligtsOn = 1;
% %         vr.worlds{vr.currentWorld}.surface.visible(:) = true;
% end
% flip the odors
% switch vr.keyPressed
%     case 264 % down for flip odors
%         temp = vr.odor1sourceLocation;
%         vr.odor1sourceLocation = vr.odor2sourceLocation;
%         vr.odor2sourceLocation = temp;
% end

% if the trigger is on, flatten the odors as the player crosses the midpoint going southward
if vr.odorFlattenTrigger && vr.previousYPositions(end-1) > vr.halfwayPoint && vr.previousYPositions(end) < vr.halfwayPoint
    vr.odorGradientOn = 0;
    vr = flattenOdorGradients(vr);
end
if vr.darknessTrigger && vr.previousYPositions(end-1) > vr.halfwayPoint && vr.previousYPositions(end) < vr.halfwayPoint
    vr.lightsOn = 0;
    vr.worlds{vr.currentWorld}.surface.visible(:) = false;
end

% deliver reward for endzone task
if vr.rewardsOn
    vr = alternateEndZoneReward(vr);
end

% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)

if vr.replayMovement
%     yPositions = vr.yPositions;
%     times = vr.times;
%     viewAngles = vr.viewAngles;
%     save('C:\Users\dombeck_lab\Desktop\Brad\replayPositionsTimes.mat','yPositions','viewAngles','times');
%     save('C:\Users\dombeck_lab\Desktop\Brad\replayPositionsTimes.mat','yPositions','times');
end

% v v v BAR v v v
% shut off all sessions

try outputSingleScan(vr.airflowSession,[9.98,.1,.1]); catch ME; end
try outputSingleScan(vr.moveRecordingAndAirflowSession,[0,0,0,9.98,.1,.1]); catch ME; end

try stop(vr.moveRecordingSession);           catch ME; end
try stop(vr.moveSession);                    catch ME; end
try stop(vr.moveRecordingSession);           catch ME; end
try stop(vr.waterSession);                   catch ME; end
try stop(vr.moveRecordingAndAirflowSession); catch ME; end
% try stop(vr.airflowSession);       catch ME; end
try stop(vr.ballMovement);         catch ME; end

% report how much water was delivered and how many rewards were earned
disp(strcat(num2str(vr.numRewards), ' rewards given including the initial one'));
disp(['That is ', num2str(vr.numRewards*4), ' uL of water']);
fclose('all'); % close save files