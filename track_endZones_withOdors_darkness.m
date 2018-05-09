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
    
vr = initializeDAQ_withOdors(vr);

% set and calculate properties of each odor
lowestFlowFraction = .01; % this is the lowest possible flow rate
vr.odor1sourceLocation = [str2double(vr.exper.variables.arenaWidth)/2, str2double(vr.exper.variables.wallThickness)]; % where the odor concentration is infinity
vr.odor2sourceLocation = [str2double(vr.exper.variables.arenaWidth)/2, str2double(vr.exper.variables.arenaLength) - str2double(vr.exper.variables.wallThickness)]; % where the odor concentration is infinity
% x=[0,sqrt(2*str2double(vr.exper.variables.arenaLength)^2)]; % min and max position for the arena
x=[0,str2double(vr.exper.variables.arenaLength)]; % y position only for the linear track
y=[1,lowestFlowFraction].*100; % max and min flow fraction
vr.flowVsDistanceConstants = polyfit(x,y,1); % constants c1 and c2 for flow = c1/x + c2
clear x y lowestFlowFraction;
vr.odorGradientOn = 1;
vr.airFlowSession.IsContinous = true;

% set properties of the predictive algorithm
vr.odorDelay = .131; % seconds
vr.yVelocityReverseTimepoints = 25;
vr.yAccelerationReverseTimepoints = 25;
vr.previousPositions = zeros(max([vr.yVelocityReverseTimepoints,vr.yAccelerationReverseTimepoints])+2,1);

% set properties of the reward
vr.timeSolenoid = 16; % in milliseconds
vr.lastEndZoneRewarded = 4; % previous reward delivery location. 1 is south end, 2 is north end, 4 is a trick to give a reward when the VR starts

vr.numRewards = 0;
% vr.turnSpeed = eval(vr.exper.variables.turnSpeed);
% vr.scaling = [7 2.8]; % forward gain, angular gain for ball movement, 2 ball revolutions / 1 world revolution
% vr.scaling = [7 1.9]; % 3 ball revolutions / 1 world revolution
vr.scaling = [7 5.6]; % 1 ball revolution / 1 world revolution
% vr.scaling = [7 3.8]; % 1.5 ball revolutions / 1 world revolution

% make the world black
vr.worlds{vr.currentWorld}.surface.visible(:) = false;

vr.startTime = now;

% give reward initially
reward(vr,vr.timeSolenoid) % added BAR
% vr.counterReward = 1; % commented BAR

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

% if vr.counterReward % commented BAR
%     reward(vr,vr.timeSolenoid) % commented BAR
%     vr.counterReward=0; % commented BAR
% end % commented BAR

% switch all odor flows to their middle value with a keystroke if desired
switch vr.keyPressed
    case 'f' % flatten gradient
        flattenOdorGradients(vr);
        vr.odorGradientOn = 0;
    case 'o' % on gradient
        vr.odorGradientOn = 1;
end



% deliver air and odors
if vr.odorGradientOn
    deliverPredictedFlows_1D(vr);
end
% deliver reward for endzone task
vr = alternateEndZoneReward(vr);

% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
vr.numRewards
