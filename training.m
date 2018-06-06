function code = training
% this is modified from singleSquareArena
% Code for the ViRMEn experiment "training".
%   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.



% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT



% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)

vr = initializeDAQ_Training(vr);

% set number of rewards
vr.numRewards = 0;

% set the amount of water (uL) that each reward gives
vr.waterPerReward = 4; 

% set properties of the reward
vr.timeSolenoid = 16; % in milliseconds
vr.rewardsOn = true;

% keep track of where the last reward was given:
% the forward endzone (from perspective of start) is endzone "2"
% the back endzone (from perspective of start) is endzone "1"
vr.lastEndZoneRewarded = 0; % start with neither end zone being the last one rewarded

% set ball movement
vr.scaling = [19.7,2.2]; % forward gain, angular gain for ball movement

% initialize starting variables
vr.startTime = now;
vr.gaveFirstReward = false;
vr.initialDropsToSend = 1;
vr.dropsToSend = 1;



% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

% deliver reward for endzone task
if vr.rewardsOn
    vr = alternateEndZoneReward(vr);
end



% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)

% try outputSingleScan(vr.moveRecordingAndAirflowSession,[0,0,0,9.98,.1,.1]); catch ME; end
try stop(vr.moveRecordingSession);           catch ME; end
try stop(vr.moveSession);                    catch ME; end
try stop(vr.moveRecordingSession);           catch ME; end
try stop(vr.waterSession);                   catch ME; end
try stop(vr.ballMovement);                   catch ME; end

% report how much water was delivered and how many rewards were earned
disp(strcat(num2str(vr.numRewards), ' rewards given NOT including the initial one'));
disp(['That is ', num2str(vr.numRewards*vr.waterPerReward), ' uL of water']); 
fclose('all'); % close save files

