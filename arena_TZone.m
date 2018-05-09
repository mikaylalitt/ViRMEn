function code = arena_TZone
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

vr.hasleftDoor = true;
vr.hasrightDoor = true;
vr.hasmidDoor = false;
vr.hasreturnLeftDoor = true;
vr.hasreturnRightDoor = true;

vr.lastDoor = 'hi';
disp(vr.lastDoor);

% set number of rewards
vr.numRewards = 0;

% allow for keeping track of last door opened
vr.lastDoor = 'hi';

% set ball movement
vr.scaling = [19.7,2.2]; % 2 meter track

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

disp('runtime');

if vr.hasleftDoor
        %vr = leftDoorControl(vr,oldWorld);
        vr = tZoneRemoveDoor(vr,oldWorld,'left');
        %vr.hasleftDoor = false;
else
        vr = tZoneReplaceDoor(vr,oldWorld,'left');
%         vr.hasleftDoor = true;
end
    
if vr.hasrightDoor
        %vr = leftDoorControl(vr,oldWorld);
        vr = tZoneRemoveDoor(vr,oldWorld,'right');
        %vr.hasrightDoor = false;
else
        vr = tZoneReplaceDoor(vr,oldWorld,'right');
%         vr.hasrightDoor = true;
end


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)

try stop(vr.waterSession);                   catch ME; end
try stop(vr.ballMovement);                   catch ME; end

% report how much water was delivered and how many rewards were earned
disp(strcat(num2str(vr.numRewards), ' rewards given including the initial one'));
disp(['That is ', num2str(vr.numRewards*4), ' uL of water']);
fclose('all'); % close save files