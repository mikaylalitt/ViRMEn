% this function is used to calibrate the water droplets released from the
% solenoid.  so, for example, if you want to get drops of 4 uL, you can
% send 1000 drops into a graduated cylinder and see if it is 4 mL.  If it
% is not, then you can try again with a different solenoid time or voltage.

% INPUTS
% solenoidTime :  time solenoid is open in ms
% dropsToSend  :  number of water drops to deliver
% highVoltage  :  number of volts to send
% lowVoltage   :  number of volts to reset to (usually zero)

function calibrateWaterReward(solenoidTime,dropsToSend,highVoltage,lowVoltage)

% initialize the DAQ
waterSession = daq.createSession('ni');
waterReward = addAnalogOutputChannel(waterSession, 'Dev1','ao0','Voltage');

% open the solenoid a bunch of times to send water drops
for drop = 1:dropsToSend
    queueOutputData(waterSession,[ones(1,solenoidTime)*highVoltage lowVoltage]');
    startBackground(waterSession);
    pause(.2); % pause for a little bit between drops
end
