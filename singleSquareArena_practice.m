function code = singleSquareArenaBig
% singleSquareArenaBig   Code for the ViRMEn experiment singleSquareArenaBig.
%   code = singleSquareArenaBig   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT



% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)



% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

if ((vr.position(1) < -21.17) && (vr.position(2) > 23))
    reward(vr,vr.timeSolenoid);
%     disp('REWARD');
    vr.counterReward=0;
end

% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
