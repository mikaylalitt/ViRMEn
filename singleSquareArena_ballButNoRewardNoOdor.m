function code = singleSquareArena_withOdors
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
vr.odor1sourceLocation = [str2double(vr.exper.variables.wallThickness), str2double(vr.exper.variables.wallThickness)]; % where the odor concentration is infinity
vr.odor2sourceLocation = [str2double(vr.exper.variables.wallThickness), str2double(vr.exper.variables.arenaLength) - str2double(vr.exper.variables.wallThickness)]; % where the odor concentration is infinity
x=[0,282.8427]; % min and max position
y=[1,lowestFlowFraction].*100; % max and min flow fraction
vr.flowVsDistanceConstants = polyfit(x,y,1); % constants c1 and c2 for flow = c1/x + c2
clear x y lowestFlowFraction;

% set properties of the reward
vr.timeSolenoid = 18; % in milliseconds
vr.lastEndZoneRewarded = 4; % previous reward delivery location. 1 is south end, 2 is north end, 4 is a trick to give a reward when the VR starts
vr.numRewards = 0;
vr.startTime = now;
vr.numRewards = 0;

% set movement properties
vr.scaling = [7 1.9]; % forward gain, angular gain for ball movement

vr.startTime = now;
% vr.turnSpeed = eval(vr.exper.variables.turnSpeed);
% vr.scaling = [13 13];

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

% output x, y, and angle via the DAQ to the clampex computer
outputSingleScan(vr.moveSession, [(mod(vr.position(4)+pi,2*pi)-pi)*vr.angleScaling, vr.position(1)*vr.xScaling+vr.xOffset, vr.position(2)*vr.yScaling+vr.yOffset]);

% deliver air and odors
% controlAirflow_squareArena(vr);
% deliver reward
% vr = alternateEndZoneReward(vr);

% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)

