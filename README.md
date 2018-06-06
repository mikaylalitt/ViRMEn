# ViRMEn

This is a project containing code for creating mazes using Virtual Reality MATLAB Engine (ViRMEn). Included is code for a straight linear track and a T-Maze.

## Getting Started
Make sure that you have the necessary software on your machine. See "Prerequisities" for more information.

### Prerequisites

* [MATLAB](https://www.mathworks.com/products/matlab.html) - Needed to run ViRMEn
* [ViRMEn](https://pni.princeton.edu/pni-software-tools/virmen) - Installation instructions for ViRMEn here

-- Note: The version of MATLAB that this code was run on is:

### Running ViRMEn

Open MATLAB. Make sure that the directory and subdirectories containing the downloaded ViRMEn zip has been added to the MATLAB path. To start ViRMEn, enter the command "virmen". 

## Mazes

There is code for two complete mazes in this repository. 

### Linear track:

The first maze is a straight linear track and is meant to train animals to run in virtual reality. For the code written, animals must alternate between each end of the track (called "endzones" in the code) in order to receive a reward. To run this maze, open the experiment:

```
arena200cmEnriched_track_endZoneTask_v2
```

Set the experiment so that it has the following settings:


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

### T-Maze:

The second maze is a t-shaped maze. The endzones are at the tips of the T, and the animals must not only alternate endzones in order to receive a reward, they must also travel back through a return hallway and then the main hallway after receiving a reward to be eligible for another reward. To run this maze, open the experiment:

```
arena_Tzone_continuous_v3
```

Set the experiment so that it has the following settings:


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

## Authors

## Acknowledgements
