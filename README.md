# ViRMEn

This is a project containing code for creating experiments using Virtual Reality MATLAB Engine (ViRMEn). Included is code for a straight linear track and a T-Maze.

## Getting Started
Make sure that you have the necessary software on your machine. See "Prerequisities" for more information.

### Prerequisites

* [MATLAB](https://www.mathworks.com/products/matlab.html) - Needed to run ViRMEn
* [ViRMEn](https://pni.princeton.edu/pni-software-tools/virmen) - Installation instructions for ViRMEn here

-- Note: The version of MATLAB that this code was run on is: R2011b

### Running ViRMEn

Open MATLAB. Make sure that the directory and subdirectories containing the downloaded ViRMEn zip has been added to the MATLAB path. To start ViRMEn, enter the command "virmen". A separate window should open with ViRMEn. To open a specific experiment from here, click on "Experiment" in the top left corner of the window, then "open" and select the experiment you would like to run.

## Experiments

There is code for two complete experiments in this repository. To deliver an initial reward (prior to running the experiment), run the following command in MATLAB:

```
calibrateWaterReward(18,5,5,0)
```

### Linear track:

The first maze is a straight linear track. For the code written, animals must alternate between each end of the track (called "endzones" in the code) in order to receive a reward. To run this track, open the experiment:

```
arena200cmEnriched_track_endZoneTask_v2
```

After the experiment has opened, set the "Experiment properties" to the following:


Movement function:
```
moveBall_1D_smooth
```

Transform function:
```
transformCylindrical
```
Experiment code:
```
training
```

To run the experimment with these properties, click the running person in the top left corner.

### T-Maze:

The second maze is a t-shaped maze. The endzones are at the tips of the T, and the animals must not only alternate endzones in order to receive a reward, they must also travel back through a return hallway and then the main hallway after receiving a reward to be eligible for another reward. To run this maze, open the experiment:

```
arena_Tzone_continuous_v3
```

Set the "Experiment properties" to the following:


Movement function:
```
moveBall_2D_smooth
```

Transform function:
```
transformCylindrical
```
Experiment code:
```
tZone_continuous_experiment3
```

## Testing
Several notes about testing code:

* To test an experiment, it is generally easier to use the keyboard for movement in the experiment. To do this, simply change the "Movement function" of the "Experiment properties" to 

```
moveWithKeyboard_builtin
```

* If you want to test an experiment on a computer that is not connected to the software that handles ball movement and delivering rewards, in the experiment code under "INITIALIZATION code" comment out the line that initializes the DAQ. For example, in the straight linear track experiment described above, you would comment out the following line in "training.m":

```
vr = initializeDAQ_Training(vr);
```

## Common Errors and Fixes

Error:

**queueOutputData cannot be called while running unless IsContinuous is set to true.**

Possible fixes to try:

* Restart MATLAB, make sure that only one ViRMEn folder is added to the MATLAB path, and try running the experiment again.

* In "reward.m", comment out the first and fourth line under "% deliver the reward:" so that the code looks like:

```
% deliver the reward:
% for drop = 1:vr.dropsToSend
    queueOutputData(vr.waterSession,[ones(1,vr.timeSolenoid)*vr.highVoltage vr.lowVoltage]');
    startBackground(vr.waterSession);
% end
```

## Authors

## Acknowledgements
